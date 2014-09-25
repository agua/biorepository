{
   "owner" : "agua",
   "location" : "bin/infoseq",
   "executor" : "",
   "installdir" : "/aguadev/apps/emboss",
   "version" : "6.4.0.0",
   "name" : "infoseq",
   "localonly" : "0",
   "description" : "Display basic information about sequences",
   "package" : "emboss",
   "parameters" : [
      {
         "locked" : null,
         "value" : "@(!$(only))",
         "args" : "",
         "chained" : 0,
         "description" : "Display 'accession' column",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-accession",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "accession",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "@(!$(only))",
         "args" : "",
         "chained" : 0,
         "description" : "Display 'database' column",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-database",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "database",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "|",
         "args" : "",
         "chained" : 0,
         "description" : "This string, which is usually a single character only, is used to delimit individual records in the text output file. It could be a space character, a tab character, a pipe character or any other character or string. (Any string)",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-delimiter",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "string",
         "category" : "string",
         "param" : "delimiter",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "@(!$(only))",
         "args" : "",
         "chained" : 0,
         "description" : "Display 'description' column",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-description",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "description",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "N",
         "args" : "",
         "chained" : 0,
         "description" : "Display 'GI' column",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-gi",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "gi",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "N",
         "args" : "",
         "chained" : 0,
         "description" : "Format output as an HTML table",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-html",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "html",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "@(!$(only))",
         "args" : "",
         "chained" : 0,
         "description" : "Display 'length' column",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-length",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "length",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "@(!$(only))",
         "args" : "",
         "chained" : 0,
         "description" : "Display 'name' column",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-name",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "name",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "Y",
         "args" : "",
         "chained" : 0,
         "description" : "Set this option on (Y) to print the sequence information into neat, aligned columns in the output file. Alternatively, leave it unset (N), in which case the information records will be delimited by a character, which you may specify by using the -delimiter option. In other words, if -columns is set on, the -delimiter option is overriden.",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-nocolumns",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "nocolumns",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "Y",
         "args" : "",
         "chained" : 0,
         "description" : "Display column headings",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-noheading",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "noheading",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "N",
         "args" : "",
         "chained" : 0,
         "description" : "This is a way of shortening the command line if you only want a few things to be displayed. Instead of specifying: '-nohead -noname -noacc -notype -nopgc -nodesc' to get only the length output, you can specify '-only -length'",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-only",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "only",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "@(!$(only))",
         "args" : "",
         "chained" : 0,
         "description" : "Display 'organism' column",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-organism",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "organism",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "stdout",
         "args" : "",
         "chained" : 0,
         "description" : "If you enter the name of a file here then this program will write the sequence details into that file.",
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
      },
      {
         "locked" : null,
         "value" : "@(!$(only))",
         "args" : "",
         "chained" : 0,
         "description" : "Display 'percent GC content' column",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-pgc",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "pgc",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "",
         "args" : "",
         "chained" : 0,
         "description" : "(Gapped) sequence(s) filename and optional format, or reference (input USA)",
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
         "value" : "N",
         "args" : "",
         "chained" : 0,
         "description" : "Display 'version' column",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-seqversion",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "seqversion",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "@(!$(only))",
         "args" : "",
         "chained" : 0,
         "description" : "Display 'type' column",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-type",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "type",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "@(!$(only))",
         "args" : "",
         "chained" : 0,
         "description" : "Display the USA of the sequence",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-usa",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "usa",
         "paramFunction" : ""
      }
   ],
   "linkurl" : "http://emboss.sourceforge.net/apps/release/6.4/emboss/apps/infoseq.html",
   "ordinal" : 0,
   "notes" : "",
   "url" : "http://www.ebi.ac.uk/Tools/emboss",
   "type" : "sequence"
}
