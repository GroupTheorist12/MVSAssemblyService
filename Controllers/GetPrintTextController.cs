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
    /*
    public class GetPrintTextController
    {
        
    }
    */

    [ApiController]
    [Route("[controller]")]

    public class GetPrintTextController : ControllerBase
    {
        private readonly ILogger<GetPrintTextController> _logger;
        private IWebHostEnvironment _environment;

        private static HostSettings? hostSettings = null;

        //private static string[] fileEntries = null;

        public string JclText
        {
            get; set;
        }

        public GetPrintTextController(ILogger<GetPrintTextController> logger, IWebHostEnvironment environment)
        {
            _logger = logger;
            _environment = environment;
            //_httpContextAccessor = httpContextAccessor;
            if (hostSettings == null)
            {
                JclText = string.Empty;
                var file = Path.Combine(_environment.ContentRootPath, "", "hostsettings.json");

                string json = System.IO.File.ReadAllText(file);
                hostSettings =
                    JsonSerializer.Deserialize<HostSettings>(json);



            }


        }

        public static int CompareFiles(string file1, string file2)
        {
            FileInfo fi1 = new FileInfo(file1);
            FileInfo fi2 = new FileInfo(file2);
            return fi2.CreationTime.CompareTo(fi1.CreationTime);
        }


        [HttpGet(Name = "GetPrintText")]
        public string Get(int index = 0)
        {
            List<JobInfo> lstJI = new List<JobInfo>();
            string homePath = (Environment.OSVersion.Platform == PlatformID.Unix ||
                   Environment.OSVersion.Platform == PlatformID.MacOSX)
    ? Environment.GetEnvironmentVariable("HOME")
    : Environment.ExpandEnvironmentVariables("%HOMEDRIVE%%HOMEPATH%");

            string[] fileEntries = Directory.GetFiles(homePath + hostSettings.JobFilePath);
            List<string> sorted = fileEntries.ToList();

            sorted.Sort(CompareFiles);

            foreach (string fil in sorted)
            {
                JobInfo ji = new JobInfo(fil);

                if (ji.IsJob)
                {
                    lstJI.Add(ji);
                }
            }



            return System.IO.File.ReadAllText(lstJI[index].Path);
        }

    }

}