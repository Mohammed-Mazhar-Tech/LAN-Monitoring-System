using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LANMonitor
{
    
        public class ArpEntry
        {
            public string MacAddress { get; set; }
            public string Type { get; set; }  // Dynamic or Static
        }
    
}