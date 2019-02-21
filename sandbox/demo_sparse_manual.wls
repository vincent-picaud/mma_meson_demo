#!/usr/bin/env wolframscript
(* ::Package:: *)

(* ::Title:: *)
(*Manual demo*)


(* ::Chapter:: *)
(*Does not use Meson build*)


<<CCompilerDriver`


SetDirectory["~/GitHub/mma_meson_demo/src"]
FileExistsQ["demo_sparse.cpp"]
libManual=CreateLibrary[{"demo_sparse.cpp"},"demo_sparse_manual"]
props=LibraryFunctionLoad[libManual,"sparse_properties",{"UTF8String",{LibraryDataType[SparseArray],"Constant"}},{_,_}]


pTable[s_] := Table[p->props[p,s],{p,{"ImplicitValue","ExplicitValues","RowPointers","ColumnIndices", "ExplicitPositions","Normal"}}] //TableForm
s=SparseArray[{{1,0,0},{2 ,0,3}}];
pTable[s]


(* ::Title:: *)
(**)
