---
title: vs2010 默认的用户属性表 Microsoft.Cpp.Win32.user.props
date: 2011-10-25 08:19:09
tags: CSDN迁移
---
   之前装了vs2008 然后装了vs2010 手贱点了套用vs2008配置

 导致重装了一夜vs2010

 希望对和我一样悲剧的人有用

 

 

 C:\Users\Administrator\AppData\Local\Microsoft\MSBuild\v4.0\Microsoft.Cpp.Win32.user.props  


 

 

 


```
<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" ToolsVersion="4.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <ImportGroup Label="PropertySheets" />
  <PropertyGroup>
    <ExecutablePath>$(VCInstallDir)bin;$(WindowsSdkDir)bin\NETFX 4.0 Tools;$(WindowsSdkDir)bin;$(VSInstallDir)Common7\Tools\bin;$(VSInstallDir)Common7\tools;$(VSInstallDir)Common7\ide;$(ProgramFiles)\HTML Help Workshop;$(FrameworkSDKDir)\bin;$(MSBuildToolsPath32);$(VSInstallDir);$(SystemRoot)\SysWow64;$(FxCopDir);$(PATH);</ExecutablePath>
    <IncludePath>$(IncludePath)</IncludePath>
    <ReferencePath>$(VCInstallDir)atlmfc\lib;$(VCInstallDir)lib</ReferencePath>
    <LibraryPath>$(LibraryPath)</LibraryPath>
    <SourcePath>$(VCInstallDir)atlmfc\src\mfc;$(VCInstallDir)atlmfc\src\mfcm;$(VCInstallDir)atlmfc\src\atl;$(VCInstallDir)crt\src;</SourcePath>
    <ExcludePath>$(VCInstallDir)include;$(VCInstallDir)atlmfc\include;$(WindowsSdkDir)include;$(FrameworkSDKDir)\include;$(MSBuildToolsPath32);$(VCInstallDir)atlmfc\lib;$(VCInstallDir)lib;</ExcludePath>
  </PropertyGroup>
</Project>
```
  
  
   
 