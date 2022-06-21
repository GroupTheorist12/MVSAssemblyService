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

    public class GetJCLFilesController : ControllerBase
    {
        private readonly ILogger<GetJCLFilesController> _logger;
        private IWebHostEnvironment _environment;



        public GetJCLFilesController(ILogger<GetJCLFilesController> logger, IWebHostEnvironment environment)
        {
            _logger = logger;
            _environment = environment;
        }



        [HttpGet(Name = "GetJCLFiles")]
        public IEnumerable<string> Get(string Chapter = "Chapter01")
        {
            List<string> lstFils = new List<string>();

            var path = _environment.ContentRootPath + "wwwroot/jcl/" + Chapter;
 
            string[] fileEntries = Directory.GetFiles(path, "*.jcl");

            foreach(string fil in fileEntries)
            {
                FileInfo fi = new FileInfo(fil);

                lstFils.Add(fi.Name);

            }
            return lstFils.ToArray();
        }

    }

}