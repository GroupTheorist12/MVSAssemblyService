    using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using System.IO;
using System.Text;
using MVSAssemblyService;
using System.Text.Json;

namespace MVSAssemblyService.Controllers
{
    [ApiController]
    [Route("[controller]")]

    public class GetJCLTextController : ControllerBase
    {
        private readonly ILogger<GetJCLTextController> _logger;
        private IWebHostEnvironment _environment;



        public string JclText
        {
            get; set;
        }

        public GetJCLTextController(ILogger<GetJCLTextController> logger, IWebHostEnvironment environment)
        {
            _logger = logger;
            _environment = environment;
        }



        [HttpGet(Name = "GetJCLText")]
        public string Get(string Chapter = "Chapter01", string JCLName = "helloaa.jcl")
        {
            var file = _environment.ContentRootPath + "wwwroot/jcl/" + Chapter + "/" + JCLName;
            
            string ret = System.IO.File.ReadAllText(file);
            //if(Environment.OSVersion.Platform == PlatformID.Win32NT)
            {
                //ret = ret.Replace("\n", Environment.NewLine);
            }

            
            return ret;
        }

    }

}