{
   "owner" : "agua",
   "location" : "bin/cacheebeyesearch",
   "executor" : "",
   "installdir" : "/aguadev/apps/emboss",
   "version" : "6.4.0.0",
   "name" : "cacheebeyesearch",
   "localonly" : "0",
   "description" : "Generates server cache file for EB-eye search domains",
   "package" : "emboss",
   "parameters" : [
      {
         "locked" : null,
         "value" : "server.$(servername)",
         "args" : "",
         "chained" : 0,
         "description" : "Server cache output file",
         "discretion" : "required",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-cachefile",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "file",
         "category" : "outfile",
         "param" : "cachefile",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "stdout",
         "args" : "",
         "chained" : 0,
         "description" : "Output file name",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-outfile",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "file",
         "category" : "outfile",
         "param" : "outfile",
         "paramFunction" : ""
      }
   ],
   "linkurl" : "http://emboss.sourceforge.net/apps/release/6.4/emboss/apps/cacheebeyesearch.html",
   "ordinal" : 0,
   "notes" : "",
   "url" : "http://www.ebi.ac.uk/Tools/emboss",
   "type" : "server"
}

