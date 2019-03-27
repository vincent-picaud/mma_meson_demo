BeginPackage["myLib`",{"CCompilerDriver`"}];

Unprotect @@ Names["myLib`*"];
ClearAll @@ Names["myLib`*"];

(*
,* User's functions
,*)
algorithm1::usage=
"algorithm1[\[Alpha]_Real,vector_?VectorQ] returns \[Alpha].vector";


Begin["`Private`"]; 

(*
,* Library name. Not yet tested under windows, works under MacOS & Linux
,*)
myLibMMAfilename=If[$OperatingSystem=="Windows","myLibMMA","libmyLibMMA"];

(*
,* Force library unload
,*)
unload::usage="Unload the library (must be called to take into account dynamic lib modifications)"
unload[]:=LibraryUnload[myLibMMAfilename]

(*
,* Use memoization to allow a faster package initialization and just in time library load
,*)
wrapAlgorithm1 := wrapAlgorithm1 = LibraryFunctionLoad[myLibMMAfilename,"algorithm1",{Real,{Real,1,"Constant"}},{Real,1}];
algorithm1[\[Alpha]_Real,vector_?VectorQ]:=Return[wrapAlgorithm1[\[Alpha],vector]];

End[]; (* Private *)


Protect @@ Names["myLib`*"];
EndPackage[];
