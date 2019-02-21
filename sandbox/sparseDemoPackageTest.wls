#!/usr/bin/env wolframscript
(* ::Package:: *)

(* ::Text:: *)
(*Be sure to reinstall a fresh version*)


SetDirectory["~/GitHub/mma_meson_demo"]
If[FileExistsQ["build"],
	Return[Import["!(cd build;ninja install)","Text"]],
	Return[Import["!(meson build;cd build;ninja install)","Text"]],
];


Needs["sparseDemoPackage`"]
