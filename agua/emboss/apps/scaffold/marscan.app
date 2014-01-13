{
   "owner" : "agua",
   "location" : "bin/marscan",
   "executor" : "",
   "installdir" : "/aguadev/apps/emboss",
   "version" : "6.4.0.0",
   "name" : "marscan",
   "localonly" : "0",
   "description" : "Finds matrix/scaffold recognition (MRS) signatures in DNA sequences",
   "package" : "emboss",
   "parameters" : [
      {
         "locked" : null,
         "value" : "*.marscan",
         "args" : "",
         "chained" : 0,
         "description" : "File for output of MAR/SAR recognition signature (MRS) regions. This contains details of the MRS in normal GFF format. The MRS consists of two recognition sites, one of 8 bp and one of 16 bp on either sense strand of the genomic DNA, within 200 bp of each other. (default -rformat gff)",
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
   "linkurl" : "http://emboss.sourceforge.net/apps/release/6.4/emboss/apps/marscan.html",
   "ordinal" : 0,
   "notes" : "",
   "url" : "http://www.ebi.ac.uk/Tools/emboss",
   "type" : "scaffold"
}

