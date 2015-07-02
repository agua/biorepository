{
   "owner" : "agua",
   "location" : "bin/emowse",
   "executor" : "",
   "installdir" : "/aguadev/apps/emboss",
   "version" : "6.4.0.0",
   "name" : "emowse",
   "localonly" : "0",
   "description" : "Search protein sequences by digest fragment molecular weight",
   "package" : "emboss",
   "parameters" : [
      {
         "locked" : null,
         "value" : "1",
         "args" : "",
         "chained" : 0,
         "description" : "Enzyme or reagent (Values: 1 (Trypsin); 2 (Lys-C); 3 (Arg-C); 4 (Asp-N); 5 (V8-bicarb); 6 (V8-phosph); 7 (Chymotrypsin); 8 (CNBr))",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-enzyme",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "string",
         "category" : "menu",
         "param" : "enzyme",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "Efreqs.dat",
         "args" : "",
         "chained" : 0,
         "description" : "Amino acid frequencies data file",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-frequencies",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "file",
         "category" : "infile",
         "param" : "frequencies",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "",
         "args" : "",
         "chained" : 0,
         "description" : "Peptide molecular weight values file",
         "discretion" : "required",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-infile",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "file",
         "category" : "infile",
         "param" : "infile",
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
         "description" : "Molecular weights data file",
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
         "value" : "*.emowse",
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
         "value" : "0.4",
         "args" : "",
         "chained" : 0,
         "description" : "Partials factor (Number from 0.100 to 1.000)",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-partials",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "decimal",
         "category" : "decimal",
         "param" : "partials",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "25",
         "args" : "",
         "chained" : 0,
         "description" : "Allowed whole sequence weight variability (Integer from 0 to 75)",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-pcrange",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "integer",
         "category" : "integer",
         "param" : "pcrange",
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
         "value" : "0.1",
         "args" : "",
         "chained" : 0,
         "description" : "Tolerance (Number from 0.100 to 1.000)",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-tolerance",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "decimal",
         "category" : "decimal",
         "param" : "tolerance",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "0",
         "args" : "",
         "chained" : 0,
         "description" : "Whole sequence molwt (Any integer value)",
         "discretion" : "required",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-weight",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "integer",
         "category" : "integer",
         "param" : "weight",
         "paramFunction" : ""
      }
   ],
   "linkurl" : "http://emboss.sourceforge.net/apps/release/6.4/emboss/apps/emowse.html",
   "ordinal" : 0,
   "notes" : "",
   "url" : "http://www.ebi.ac.uk/Tools/emboss",
   "type" : "protein"
}
