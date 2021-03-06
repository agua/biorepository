{
   "owner" : "agua",
   "location" : "bin/est2genome",
   "executor" : "",
   "installdir" : "/aguadev/apps/emboss",
   "version" : "6.4.0.0",
   "name" : "est2genome",
   "localonly" : "0",
   "description" : "Align EST sequences to genomic DNA sequence",
   "package" : "emboss",
   "parameters" : [
      {
         "locked" : null,
         "value" : "",
         "args" : "",
         "chained" : 0,
         "description" : "Show the alignment. The alignment includes the first and last 5 bases of each intron, together with the intron width. The direction of splicing is indicated by angle brackets (forward or reverse) or ???? (unknown).",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-align",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "align",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "",
         "args" : "",
         "chained" : 0,
         "description" : "Spliced EST nucleotide sequence(s)",
         "discretion" : "required",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-estsequence",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "string",
         "category" : "seqall",
         "param" : "estsequence",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "2",
         "args" : "",
         "chained" : 0,
         "description" : "Cost for deleting a single base in either sequence, excluding introns (Any integer value)",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-gappenalty",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "integer",
         "category" : "integer",
         "param" : "gappenalty",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "",
         "args" : "",
         "chained" : 0,
         "description" : "Unspliced genomic nucleotide sequence",
         "discretion" : "required",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-genomesequence",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "string",
         "category" : "sequence",
         "param" : "genomesequence",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "40",
         "args" : "",
         "chained" : 0,
         "description" : "Cost for an intron, independent of length. (Any integer value)",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-intronpenalty",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "integer",
         "category" : "integer",
         "param" : "intronpenalty",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "1",
         "args" : "",
         "chained" : 0,
         "description" : "Score for matching two bases (Any integer value)",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-match",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "integer",
         "category" : "integer",
         "param" : "match",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "30",
         "args" : "",
         "chained" : 0,
         "description" : "Exclude alignments with scores below this threshold score. (Any integer value)",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-minscore",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "integer",
         "category" : "integer",
         "param" : "minscore",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "1",
         "args" : "",
         "chained" : 0,
         "description" : "Cost for mismatching two bases (Any integer value)",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-mismatch",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "integer",
         "category" : "integer",
         "param" : "mismatch",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "both",
         "args" : "",
         "chained" : 0,
         "description" : "This determines the comparison mode. The default value is 'both', in which case both strands of the est are compared assuming a forward gene direction (ie GT/AG splice sites), and the best comparison redone assuming a reversed (CT/AC) gene splicing direction. The other allowed modes are 'forward', when just the forward strand is searched, and 'reverse', ditto for the reverse strand. (Values: both (Both strands); forward (Forward strand only); reverse (Reverse strand only))",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-mode",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "string",
         "category" : "menu",
         "param" : "mode",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "Y",
         "args" : "",
         "chained" : 0,
         "description" : "You can print out all comparisons instead of just the best one by setting this to be false.",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-nobest",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "nobest",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "Y",
         "args" : "",
         "chained" : 0,
         "description" : "Use donor and acceptor splice sites. If you want to ignore donor-acceptor sites then set this to be false.",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-nousesplice",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "nousesplice",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "*.est2genome",
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
         "description" : "Reverse the orientation of the EST sequence",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-reverse",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "boolean",
         "category" : "boolean",
         "param" : "reverse",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "20825",
         "args" : "",
         "chained" : 0,
         "description" : "Random number seed (Any integer value)",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-seed",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "integer",
         "category" : "integer",
         "param" : "seed",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "0",
         "args" : "",
         "chained" : 0,
         "description" : "Shuffle (Any integer value)",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-shuffle",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "integer",
         "category" : "integer",
         "param" : "shuffle",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "10.0",
         "args" : "",
         "chained" : 0,
         "description" : "For linear-space recursion. If product of sequence lengths divided by 4 exceeds this then a divide-and-conquer strategy is used to control the memory requirements. In this way very long sequences can be aligned. If you have a machine with plenty of memory you can raise this parameter (but do not exceed the machine's physical RAM) (Any numeric value)",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-space",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "decimal",
         "category" : "decimal",
         "param" : "space",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "20",
         "args" : "",
         "chained" : 0,
         "description" : "Cost for an intron, independent of length and starting/ending on donor-acceptor sites (Any integer value)",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-splicepenalty",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "integer",
         "category" : "integer",
         "param" : "splicepenalty",
         "paramFunction" : ""
      },
      {
         "locked" : null,
         "value" : "50",
         "args" : "",
         "chained" : 0,
         "description" : "Alignment width (Any integer value)",
         "discretion" : "optional",
         "inputParams" : "",
         "ordinal" : 0,
         "argument" : "-width",
         "format" : "",
         "paramtype" : "input",
         "valuetype" : "integer",
         "category" : "integer",
         "param" : "width",
         "paramFunction" : ""
      }
   ],
   "linkurl" : "http://emboss.sourceforge.net/apps/release/6.4/emboss/apps/est2genome.html",
   "ordinal" : 0,
   "notes" : "",
   "url" : "http://www.ebi.ac.uk/Tools/emboss",
   "type" : "repeat"
}

