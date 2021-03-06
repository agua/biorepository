{
   "owner" : "admin",
   "location" : "bin/banana",
   "executor" : "",
   "installdir" : "/aguadev/apps/emboss",
   "version" : "6.6.0.0",
   "name" : "banana",
   "localonly" : "0",
   "description" : "Plot bending and curvature data for B-DNA",
   "package" : "emboss",
   "parameters" : [
      {
         "locked" : null,
         "value" : "Eangles_tri.dat",
         "args" : "",
         "chained" : 0,
         "description" : "DNA base trimer roll angles data file",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-anglesfile",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "file",
         "category" : "infile",
         "param" : "anglesfile",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "$EMBOSS_GRAPHICS value, or x11",
         "args" : "",
         "chained" : 0,
         "description" : "Graph type (ps, hpgl, hp7470, hp7580, meta, cps, x11, tek, tekt, none, data, xterm, svg)",
         "discretion" : "required",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-graph",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "ps|hpgl|hp7470|hp7580|meta|cps|x11|tek|tekt|none|data|xterm|svg",
         "category" : "ingraph",
         "param" : "graph",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "banana.profile",
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
      },
      {
         "locked" : null,
         "value" : "50",
         "args" : "",
         "chained" : 0,
         "description" : "Number of residues to be displayed on each line (Any integer value)",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-residuesperline",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "integer",
         "category" : "integer",
         "param" : "residuesperline",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "",
         "args" : "",
         "chained" : 0,
         "description" : "Nucleotide sequence filename and optional format, or reference (input USA)",
         "discretion" : "required",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-sequence",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "string",
         "category" : "sequence",
         "param" : "sequence",
         "paramFunction" : ""
      }
   ],
   "linkurl" : "http://emboss.sourceforge.net/apps/release/6.4/emboss/apps/banana.html",
   "ordinal" : 0,
   "notes" : "",
   "url" : "http://archive.ubuntu.com/ubuntu/pool/universe/e/emboss/emboss_$version.orig.tar.gz",
   "type" : "structure"
}

