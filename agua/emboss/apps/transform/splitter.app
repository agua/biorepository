{
   "owner" : "agua",
   "location" : "bin/splitter",
   "executor" : "",
   "installdir" : "/aguadev/apps/emboss",
   "version" : "6.4.0.0",
   "name" : "splitter",
   "localonly" : "0",
   "description" : "Split sequence(s) into smaller sequences",
   "package" : "emboss",
   "parameters" : [
      {
         "locked" : null,
         "value" : "N",
         "args" : "",
         "chained" : 0,
         "description" : "Include overlap in output sequence size",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-addoverlap",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "addoverlap",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "N",
         "args" : "",
         "chained" : 0,
         "description" : "Use feature information",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-feature",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "feature",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "<sequence>.<format>",
         "args" : "",
         "chained" : 0,
         "description" : "Sequence set(s) filename and optional format (output USA)",
         "discretion" : "required",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-outseq",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "file",
         "category" : "outfile",
         "param" : "outseq",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "0",
         "args" : "",
         "chained" : 0,
         "description" : "Overlap between split sequences (Integer 0 or more)",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-overlap",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "integer",
         "category" : "integer",
         "param" : "overlap",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "",
         "args" : "",
         "chained" : 0,
         "description" : "Sequence(s) filename and optional format, or reference (input USA)",
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
      },
      {
         "locked" : null,
         "value" : "10000",
         "args" : "",
         "chained" : 0,
         "description" : "Size to split at (Integer 1 or more)",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-size",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "integer",
         "category" : "integer",
         "param" : "size",
         "paramFunction" : ""
      }
   ],
   "linkurl" : "http://emboss.sourceforge.net/apps/release/6.4/emboss/apps/splitter.html",
   "ordinal" : 0,
   "notes" : "",
   "url" : "http://www.ebi.ac.uk/Tools/emboss",
   "type" : "transform"
}
