{
   "owner" : "agua",
   "location" : "bin/chaos",
   "executor" : "",
   "installdir" : "/aguadev/apps/emboss",
   "version" : "6.4.0.0",
   "name" : "chaos",
   "localonly" : "0",
   "description" : "Draw a chaos game representation plot for a nucleotide sequence",
   "package" : "emboss",
   "parameters" : [
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
   "linkurl" : "http://emboss.sourceforge.net/apps/release/6.4/emboss/apps/chaos.html",
   "ordinal" : 0,
   "notes" : "",
   "url" : "http://www.ebi.ac.uk/Tools/emboss",
   "type" : "sequence"
}

