{
   "owner" : "admin",
   "location" : "bin/geecee",
   "executor" : "",
   "installdir" : "/aguadev/apps/emboss",
   "version" : "6.6.0.0",
   "name" : "geecee",
   "localonly" : "0",
   "description" : "Calculate fractional GC content of nucleic acid sequences",
   "package" : "emboss",
   "parameters" : [
      {
         "locked" : null,
         "value" : "*.geecee",
         "args" : "",
         "chained" : 0,
         "description" : "Output file name",
         "discretion" : "required",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-outfile",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "file",
         "category" : "outfile",
         "param" : "outfile",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "",
         "args" : "",
         "chained" : 0,
         "description" : "Nucleotide sequence(s) filename and optional format, or reference (input USA)",
         "discretion" : "required",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-sequence",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "string",
         "category" : "seqall",
         "param" : "sequence",
         "paramFunction" : ""
      }
   ],
   "linkurl" : "http://emboss.sourceforge.net/apps/release/6.4/emboss/apps/geecee.html",
   "ordinal" : 0,
   "notes" : "",
   "url" : "http://archive.ubuntu.com/ubuntu/pool/universe/e/emboss/emboss_$version.orig.tar.gz",
   "type" : "nucleotide"
}

