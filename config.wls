libraryLinkIncludeDirectories={FileNameJoin[{$InstallationDirectory,"SystemFiles","IncludeFiles","C"}],
			       FileNameJoin[{$InstallationDirectory,"SystemFiles","Links","MathLink","DeveloperKit",$SystemID,"CompilerAdditions"}]};
libraryInstallDirectory=FileNameJoin[{$UserBaseDirectory,"SystemFiles","LibraryResources",$SystemID}];
packageInstallDirectory=FileNameJoin[{$UserBaseDirectory,"Applications"}];

(* MMA < v10.1 does not have native StringRiffle *)
stringRiffle[stringList_List,sep_String]:=TextString[stringList, ListFormat -> {"", sep, ""}];
format[s_List]:=stringRiffle[s,","]

(* stdout result *)
Print[format[libraryLinkIncludeDirectories]<>";"<>libraryInstallDirectory<>";"<>packageInstallDirectory]

