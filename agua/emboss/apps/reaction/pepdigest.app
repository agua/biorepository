{
   "owner" : "agua",
   "location" : "bin/pepdigest",
   "executor" : "",
   "installdir" : "/aguadev/apps/emboss",
   "version" : "6.4.0.0",
   "name" : "pepdigest",
   "localonly" : "0",
   "description" : "Reports on protein proteolytic enzyme or reagent cleavage sites",
   "package" : "emboss",
   "parameters" : [
      {
         "locked" : null,
         "value" : "",
         "args" : "",
         "chained" : 0,
         "description" : "As for overlap but fragments containing more than one potential cut site are included.",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-allpartials",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "allpartials",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "1",
         "args" : "",
         "chained" : 0,
         "description" : "Select number (Values: 1 (Trypsin); 2 (Lys-C); 3 (Arg-C); 4 (Asp-N); 5 (V8-bicarb); 6 (V8-phosph); 7 (Chymotrypsin); 8 (CNBr))",
         "discretion" : "required",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-menu",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "string",
         "category" : "menu",
         "param" : "menu",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "N",
         "args" : "",
         "chained" : 0,
         "description" : "Use monoisotopic weights",
         "discretion" : "required",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-mono",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "mono",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "Emolwt.dat",
         "args" : "",
         "chained" : 0,
         "description" : "Molecular weight data for amino acids",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-mwdata",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "file",
         "category" : "infile",
         "param" : "mwdata",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "*.pepdigest",
         "args" : "",
         "chained" : 0,
         "description" : "Output report file name (default -rformat seqtable)",
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
         "description" : "Used for partial digestion. Shows all cuts from favoured cut sites plus 1..3, 2..4, 3..5 etc but not (e.g.) 2..5. Overlaps are therefore fragments with exactly one potential cut site within it.",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-overlap",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "overlap",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "",
         "args" : "",
         "chained" : 0,
         "description" : "Allows semi-specific and non-specific digestion. This option is particularly useful for generating lists of peptide sequences for protein identification using mass-spectrometry.",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-ragging",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "ragging",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "",
         "args" : "",
         "chained" : 0,
         "description" : "Protein sequence(s) filename and optional format, or reference (input USA)",
         "discretion" : "required",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-seqall",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "string",
         "category" : "seqall",
         "param" : "seqall",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "1",
         "args" : "",
         "chained" : 0,
         "description" : "Select number (Values: 1 (none); 2 (nterm); 3 (cterm); 4 (nterm OR cterm))",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-termini",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "string",
         "category" : "menu",
         "param" : "termini",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "",
         "args" : "",
         "chained" : 0,
         "description" : "Trypsin will not normally cut after 'KR' if they are followed by any of 'KRIFLP'. Lys-C will not normally cut after 'K' if it is followed by 'P'. Arg-C will not normally cut after 'R' if it is followed by 'P'. V8-bicarb will not normally cut after 'E' if it is followed by any of 'KREP'. V8-phosph will not normally cut after 'DE' if they are followed by 'P'. Chymotrypsin will not normally cut after 'FYWLM' if they are followed by 'P'. Specifying unfavoured shows these unfavoured cuts as well as the favoured ones.",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-unfavoured",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "unfavoured",
         "paramFunction" : ""
      }
   ],
   "linkurl" : "http://emboss.sourceforge.net/apps/release/6.4/emboss/apps/pepdigest.html",
   "ordinal" : 0,
   "notes" : "",
   "url" : "http://www.ebi.ac.uk/Tools/emboss",
   "type" : "reaction"
}
