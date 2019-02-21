#!/usr/bin/env wolframscript
(* ::Package:: *)

<<CCompilerDriver`


SetDirectory["~/GitHub/mma_meson_demo"]
lib=FileNameJoin[{Directory[],"build/src/libdemo_sparse.so"}]
FileExistsQ[lib]
props=LibraryFunctionLoad[lib,"sparse_properties",{"UTF8String",{LibraryDataType[SparseArray],"Constant"}},{_,_}]


pTable[s_] := Table[p->props[p,s],{p,{"ImplicitValue","ExplicitValues","RowPointers","ColumnIndices", "ExplicitPositions","Normal"}}] //TableForm
s=SparseArray[{{1,0,0},{2 ,0,3}}];
pTable[s]
