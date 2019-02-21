libraryLinkIncludeDirectories={FileNameJoin[{$InstallationDirectory,"SystemFiles","IncludeFiles","C"}],
			       FileNameJoin[{$InstallationDirectory,"SystemFiles","Links","MathLink","DeveloperKit",$SystemID,"CompilerAdditions"}]};
libraryInstallDirectory=FileNameJoin[{$UserBaseDirectory,"SystemFiles","LibraryResource",$SystemID}];
packageInstallDirectory=FileNameJoin[{$UserBaseDirectory,"Applications"}];

buildDirectory=Environment["MESON_BUILD_ROOT"];

format[s_List]:=StringRiffle[s,","]
Print[format[libraryLinkIncludeDirectories]<>";"<>libraryInstallDirectory<>";"<>packageInstallDirectory]

(*Export["libraryLinkIncludeDirectories.conf",format[libraryLinkIncludeDirectories],"Text"];*)

(* format[s_String]:="'"<>s<>"'"; *)
(* format[s_List]:="[ "<>StringRiffle[Map[format,s],","]<>" ]"; *)

(* Print[format[{libraryLinkIncludeDirectories,libraryInstallDirectory,packageInstallDirectory}]]; *)
