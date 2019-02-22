#!/usr/bin/env wolframscript
(* ::Package:: *)

(* ::Chapter:: *)
(*Automatic install using Meson*)


(* ::Text:: *)
(*Clone git repo*)


SetDirectory[$TemporaryDirectory];
If[!FileExistsQ["mma_meson_demo"],
   Import["!git clone git@github.com:vincent-picaud/mma_meson_demo.git 2>&1","Text"]
];


(* ::Text:: *)
(*Compile & Install*)


SetDirectory[FileNameJoin[{$TemporaryDirectory,"mma_meson_demo"}]]
If[FileExistsQ["build"],
	Return[Import["!(cd build;ninja install) 2>&1","Text"]],
	Return[Import["!(meson build;cd build;ninja install) 2>&1","Text"]],
];


(* ::Text:: *)
(*Tests*)


Needs["sparseDemoPackage`"]


?sparseDemoPackage`*


s=SparseArray[{{1,0,0},{2 ,0,3}}]


test[s] // TableForm
