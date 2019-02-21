libraryLinkIncludeDirectories={FileNameJoin[{$InstallationDirectory,"SystemFiles","IncludeFiles","C"}],
			       FileNameJoin[{$InstallationDirectory,"SystemFiles","Links","MathLink","DeveloperKit",$SystemID,"CompilerAdditions"}]};
libraryInstallDirectory={FileNameJoin[{$UserBaseDirectory,"SystemFiles","LibraryResource",$SystemID}]};
packageInstallDirectory={FileNameJoin[{$UserBaseDirectory,"Applications"}]};

format[s_String]:="'"<>s<>"'";
format[s_List]:="[ "<>StringRiffle[Map[format,s],","]<>" ]";

Print[format[{libraryLinkIncludeDirectories,libraryInstallDirectory,packageInstallDirectory}]];
