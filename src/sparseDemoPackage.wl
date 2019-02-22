(* ::Package:: *)

(* Comment: a Meson + MMA LibraryLink integration proof of concept, see https://github.com/vincent-picaud/mma_meson_demo *)


BeginPackage["sparseDemoPackage`",{"CCompilerDriver`"}];
Unprotect @@ Names["sparseDemoPackage`*"];
ClearAll @@ Names["sparseDemoPackage`*"];


test::usage=
"test[sparseArray_SparseArray] tests the sparse_properties C function (LibraryLink)";


Begin["`Private`"];

functionToTest := functionToTest = LibraryFunctionLoad["demo_sparse", 
						       "sparse_properties",
						       {"UTF8String", {LibraryDataType[SparseArray], "Constant"}},
						       {_, _}];

test[sparseArray_SparseArray]:=
	Return[Table[property -> functionToTest[property, sparseArray],
		     {property, {"ImplicitValue", "ExplicitValues", "RowPointers",
				 "ColumnIndices", "ExplicitPositions", "Normal"}}]];

End[]; (* Private *)


Protect @@ Names["sparseDemoPackage`*"];
EndPackage[];
