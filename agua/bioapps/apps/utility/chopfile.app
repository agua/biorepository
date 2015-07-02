{
   "owner" : "agua",
   "location" : "bin/utils/chopfile.pl",
   "executor" : "/usr/bin/perl",
   "installdir" : "/agua/0.6/t/bin/Agua/Ops/Install/outputs/bioapps",
   "version" : "0.6.0",
   "name" : "chopfile",
   "localonly" : "0",
   "description" : "Print a user-defined number of lines from one file to another file",
   "package" : "bioapps",
   "parameters" : [
      {
         "locked" : "0",
         "value" : "",
         "args" : "output.outputfile.value,input.outputfile.value",
         "description" : "Print lines from this source file",
         "discretion" : "essential",
         "inputParams" : "",
         "ordinal" : "1",
         "argument" : "--inputfile",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "file",
         "category" : "inputfile",
         "param" : "inputfile",
         "paramFunction" : ""
      },
      {
         "locked" : "0",
         "value" : "",
         "args" : "",
         "description" : "Print this number of lines",
         "discretion" : "required",
         "inputParams" : "",
         "ordinal" : "1",
         "argument" : "--lines",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "integer",
         "category" : "lines",
         "param" : "lines",
         "paramFunction" : ""
      },
      {
         "locked" : "0",
         "value" : "",
         "args" : "",
         "description" : "Start printing lines from the inputfile after this number of lines",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : "1",
         "argument" : "--offset",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "integer",
         "category" : "lines",
         "param" : "offset",
         "paramFunction" : ""
      },
      {
         "locked" : "0",
         "value" : "",
         "args" : "",
         "description" : "Print lines to this target file",
         "discretion" : "required",
         "inputParams" : "",
         "ordinal" : "1",
         "argument" : "--outputfile",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "file",
         "category" : "inputfile",
         "param" : "outputfile",
         "paramFunction" : ""
      },
      {
         "locked" : "0",
         "value" : "",
         "args" : "input.outputfile.value",
         "description" : "File containing the user-specified number of lines from the inputfile, starting from the offset (default: 0)",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : "1",
         "argument" : "",
         "format" : "",
         "paramtype" : "output",
         "valuetype" : "file",
         "category" : "outputfile",
         "param" : "outputfile",
         "paramFunction" : ""
      }
   ],
   "ordinal" : null,
   "notes" : " ",
   "url" : "http://www.aguadev.org/confluence/display/howto/Bioapps+API",
   "type" : "utility"
}
