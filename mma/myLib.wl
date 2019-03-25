BeginPackage["myLib`",{"CCompilerDriver`"}];

Unprotect @@ Names["myLib`*"];
ClearAll @@ Names["myLib`*"];

(*
,* User's functions
,*)
algorithm1::usage=
"algorithm1[signal_VectorQ,halfwidth_] return baseline found by algorithm1 method";


Begin["`Private`"]; 

(*
,* Library name. Not yet tested under windows, works under OS Mac & Linux
,*)
myLibMMAfilename=If[$OperatingSystem=="Windows","myLibMMA","libmyLibMMA"];

(*
,* Force library unload
,*)
unload::usage="Unload the library (must be called to take into accound dynamic lib modifications)"
unload[]:=LibraryUnload[myLibMMAfilename]

(*
,* Use memoization to allow a faster package initialization and just in time library load
,*)
wrapAlgorithm1 := wrapAlgorithm1 = LibraryFunctionLoad[myLibMMAfilename,"algorithm1",{{Real,1,"Constant"},Integer},{Real,1}];
algorithm1[signal_?VectorQ,halfwidth_Integer]:=Return[wrapAlgorithm1[signal,halfwidth]];

End[]; (* Private *)


Protect @@ Names["myLib`*"];
EndPackage[];
