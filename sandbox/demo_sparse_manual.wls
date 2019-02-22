#!/usr/bin/env wolframscript
(* ::Package:: *)

(* ::Title:: *)
(*"Manual" build, without using Meson*)


(* ::Text:: *)
(*Clone git repo*)


SetDirectory[$TemporaryDirectory];
If[!FileExistsQ["mma_meson_demo"],
   Import["!git clone git@github.com:vincent-picaud/mma_meson_demo.git 2>&1","Text"]
];


(* ::Text:: *)
(*Compile & Install*)


<<CCompilerDriver`


SetDirectory["~/GitHub/mma_meson_demo/src"]
FileExistsQ["demo_sparse.cpp"]
libManual=CreateLibrary[{"demo_sparse.cpp"},"demo_sparse_manual"]
props=LibraryFunctionLoad[libManual,"sparse_properties",{"UTF8String",{LibraryDataType[SparseArray],"Constant"}},{_,_}]


(* ::Text:: *)
(*Tests*)


pTable[s_] := Table[p->props[p,s],{p,{"ImplicitValue","ExplicitValues","RowPointers","ColumnIndices", "ExplicitPositions","Normal"}}] //TableForm
s=SparseArray[{{1,0,0},{2 ,0,3}}];
pTable[s]


(* ::Title:: *)
(**)
