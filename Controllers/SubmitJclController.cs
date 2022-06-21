using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.IO;
using System.Threading.Tasks;
using System.Net.Sockets;
using System.Text;
using System.Text.Json;



namespace  MVSAssemblyService.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class SubmitJclController : ControllerBase
    {
        private readonly ILogger<SubmitJclController> _logger;
        private IWebHostEnvironment _environment;

        private static HostSettings? hostSettings = null;


        public SubmitJclController(ILogger<SubmitJclController> logger, IWebHostEnvironment environment)
        {
            _logger = logger;
            _environment = environment;

            if (hostSettings == null)
            {
                var file = Path.Combine(_environment.ContentRootPath, "", "hostsettings.json");

                string json = System.IO.File.ReadAllText(file);
                hostSettings =
                    JsonSerializer.Deserialize<HostSettings>(json);


            }

        }

        [HttpPost(Name = "SubmitJcl")]
        public string Post([FromBody] JobSubmitRequest jsr)
        {

            var file = _environment.ContentRootPath + "wwwroot/jcl/" + jsr.Chapter + "/" + jsr.JclFile;

            using TcpClient tcpClient = new TcpClient();
            tcpClient.Connect(hostSettings.Host, int.Parse(hostSettings.Port));
            using NetworkStream netStream = tcpClient.GetStream();


            string JclText = System.IO.File.ReadAllText(file).Trim();
            byte[] sendBuffer = Encoding.ASCII.GetBytes(JclText);
            netStream.Write(sendBuffer);

            return JclText;
        }


    }
}