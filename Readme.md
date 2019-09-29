# Eiffel-Loop Library

## Contents

* RELEASE NOTES
* LIBRARY CONTENTS
* INSTALLATION
* BUILDING THE EXAMPLES
* ENVIRONMENT VARIABLES MANAGEMENT
* USING THE EIFFEL LOOP SCONS BUILD SYSTEM
* EXAMPLE APPLICATIONS
* SOURCE TREE DESCRIPTIONS

## RELEASE NOTES 

[doc/Release-1.4.9.md (future)](doc/Release-1.4.9.md)

[doc/Release-1.4.8.md (current)](doc/Release-1.4.8.md)

[doc/Release-1.4.7.md](doc/Release-1.4.7.md)

[doc/Release-1.4.6.md](doc/Release-1.4.6.md)

[doc/Release-1.4.5.md](doc/Release-1.4.5.md)

[doc/Release-1.4.4.md](doc/Release-1.4.4.md)

[doc/Release-1.4.3.md](doc/Release-1.4.3.md)

[doc/Release-1.4.2.md](doc/Release-1.4.2.md)

[doc/Release-1.4.1.md](doc/Release-1.4.1.md)

[doc/Release-1.4.0.md](doc/Release-1.4.0.md)

[doc/Release-1.3.4.md](doc/Release-1.3.4.md)

[doc/Release-1.3.3.md](doc/Release-1.3.3.md)

[doc/Release-1.3.2.md](doc/Release-1.3.2.md)

[doc/Release-1.2.6.md](doc/Release-1.2.6.md)


## LIBRARY CONTENTS
For a short description of each module see [doc/Contents.md](doc/Contents.md) or [www.eiffel-loop.com](http://www.eiffel-loop.com).

## INSTALLATION

### Requirements

**EiffelStudio 16.05**
It will take considerable work to migrate Eiffel-Loop to EiffelStudio 19.05 and beyond. Unfortunately Finnian has to prioritize making his Matryohska project a commercial success before undertaking a migration of Eiffel-Loop to 19.05.

* Variables `ISE_PLATFORM`, `ISE_EIFFEL` and `ISE_C_COMPILER` should be defined. The estudio command must be in your path.
* Python 2.6.x or 2.7.x. Versions >= 3.0 are not compatible with the [scons](http://www.scons.org/) builder. The python command must be in your path.

#### For Windows

* Microsoft [Windows SDK](http://www.microsoft.com/en-us/download/details.aspx?id=8279) for Windows 7.
* Using the `eiffel2python` library requires the header files and libraries from the 64-bit version of Python when compiling with the 64-bit version of EiffelStudio. Similarly for 32-bit compilations. This is a precondition for compiling the test.ecf project.

#### For Unix

* Use a "manual install" of EiffelStudio and not the Debian package. The Debian package installs library files in odd places causing C compilation errors with Eiffel-Loop.

### Setup Procedure

Unzip the Eiffel-Loop archive to a development directory and then open a terminal window. Change to the Eiffel-Loop home directory and run the setup script. For Unix the command is:

   . setup.sh

And for Windows:

   setup

Note that for Windows 7/Vista you should open the terminal console with administrator permissions.

The script achieves the following things.

1. Installs extensions to [scons](http://www.scons.org/) for building Eiffel projects.
2. Installs [scons](http://www.scons.org/) if it is not already installed.
3. Installs Python package [lxml](http://lxml.de/) if not already installed.
4. Builds the Eiffel toolkit program el_toolkit, which amongst other things, can convert [Pyxis](http://www.eiffelroom.com/node/527) files to XML and vice-versa.
5. If the [gedit](http://projects.gnome.org/gedit/) text editor is installed, syntax highlighting support for [Pyxis](http://www.eiffelroom.com/node/527) Eiffel Configuration files and generic [Pyxis](http://www.eiffelroom.com/node/527) files is installed.
6. A bonus for Windows:
   * [gedit](http://projects.gnome.org/gedit/) is associated with [.pecf](http://www.eiffelroom.com/node/654#Gedit_Syntax_Highlighting) files
   * The [Pyxis](http://www.eiffelroom.com/node/527) converter program is associated with [.pecf](http://www.eiffelroom.com/node/654#Gedit_Syntax_Highlighting) files and accessible from an entry in the right-click context menu, `Convert to ECF`.

## BUILDING THE EXAMPLES

### Finalized Build

Open a terminal console and change to the project directory. Use this command to do a finalized build.

   scons project=[PROJECT NAME] action=finalize

Note that you can refer to the Eiffel project file using either the [.ecf](https://dev.eiffel.com/Configuration) or pecf file extension. In the case of a pecf file, it is first converted to [.ecf](https://dev.eiffel.com/Configuration) format as part of the build.
#### Build Output
The output from the build can be found in this directory under the project directory:

   package/$ISE_PLATFORM/bin

### Browsing in EiffelStudio

Before the examples can be opened in EiffelStudio, it is first necessary to build any C or Java dependencies using a [scons](http://www.scons.org/) build. To do this, open a terminal console and change to the project directory. Use this command to build a `W_code` project for use in EiffelStudio.

   scons project=[PROJECT NAME] action=freeze

Note that you can refer to the Eiffel project file using either the [.ecf](https://dev.eiffel.com/Configuration) or [.pecf](http://www.eiffelroom.com/node/654#Gedit_Syntax_Highlighting) file extension. In the case of a [.pecf](http://www.eiffelroom.com/node/654#Gedit_Syntax_Highlighting) file, it is first converted to [.ecf](https://dev.eiffel.com/Configuration) format as part of the build.

After the build completes use the following command to open the project in EiffelStudio.

   launch_estudio [PROJECT NAME]

As with the [scons](http://www.scons.org/) command, you can use either the [.ecf](https://dev.eiffel.com/Configuration) or [.pecf](http://www.eiffelroom.com/node/654#Gedit_Syntax_Highlighting) project  file. The launch_estudio command sets up the correct  environment for the project.

### Toolkit Program

#### Requirements -ftp_backup option

The following command line utilities must be in your path:

   tar, gpg, gzip

### Manage MP3 Example

A selection of command line tools for use with the [Rhythmbox](http://en.wikipedia.org/wiki/Rhythmbox) audio player.
Requirements `-create_cortina_set` option
The following command line utilities must be in your path:

   avconv, lame, sox

## ENVIRONMENT VARIABLES MANAGEMENT

Eiffel-Loop has a system for automatically setting environment variables for a project, either when you open it in EiffelStudio using the `launch_estudio` command, or when building it on the command line using the *Eiffel-Loop* [scons](http://www.scons.org/) based build system.

The environment manager assumes that your Eiffel development directory has a structure like the following:

```
|-- Eiffel
|   |-- library
|   |   |-- Eiffel-Loop
|   |   |-- eGMP
|   |   |-- eposix-3.2.1
|   |   |-- log4e
|   |   `-- and so forth..
|   |-- project-1
|   |-- project-2
|   |-- project-3
|   |-- and so forth..
```
The development root is either a directory path that ends with the step name `Eiffel`, or else is a path defined by an environment variable `EIFFEL`. The manager assumes that there is a directory named `library` in your Eiffel root directory containing all third party Eiffel libraries. It then creates environment variables based on the directory names in `library`, but ignoring any version numbers. So for example if it finds a directory `eposix-3.2.1` it will add an evironment path variable `EPOSIX`. The names are uppercased and any hyphens are substituted with an underscore so `Eiffel-Loop` becomes `EIFFEL_LOOP`.

In addition it adds valid values for these variables: `JDK_HOME, PYTHON_HOME, PYTHON_LIB_NAME` as well as the following *Eiffel-Loop* variables:

```
EL_CONTRIB = $EIFFEL_LOOP/contrib
EL_C_LIB = $EIFFEL_LOOP/C_library

```
### Overriding the Defaults
However you can override the defaults or add your own environment variables by creating a `project.py` file in your project directory and calling the procedure `set_environ`. Infact you need this file anyway to use the build system or the `launch_estudio` command. Here is an example that sets the `LD_LIBRARY_PATH` variable. You can use any valid Python 2.7 code in the `project.py` file.

```python
# EiffelStudio project environment

from eiffel_loop.eiffel.dev_environ import *

version = (1, 0, 4); build = 223

installation_sub_directory = 'Eiffel-Loop/test'

set_environ ('LD_LIBRARY_PATH', "$EL_C_LIB/svg-graphics/spec/$ISE_PLATFORM")

```
### Under the Hood
To understand how the default environment is constructed, read the source text of the following Python modules found in: `Eiffel-Loop/tool/python-support`:

```
eiffel_loop.eiffel.project
eiffel_loop.os.environ
eiffel_loop.project
```

If you make any modifications you can activate them by running the Eiffel-Loop setup script again, or adding `Eiffel-Loop/tool/python-support` to the PYTHONPATH variable.

## USING THE EIFFEL LOOP SCONS BUILD SYSTEM

### Python eiffel_loop package

During setup, a Python package called eiffel_loop is installed. This contains extensions to scons for building Eiffel systems.The source code can be found in:

   Eiffel-Loop/tool/python-support

Features of this build system are as follows:

* Cross compilation.
* Managing of resource files and shareable object dependencies to create installable packages.
* Ability to download and extract prebuilt binaries from zip files using special source files with extension `*.get*`. The second asterisk corresponds to  target extensions like *dll*, *def*, *jar* and so forth. They are managed in the same way as C source files. The binaries could be any kind of shareable objects including Java jars.
* Generates Eiffel source file with build version information available. This is accessed through once variable: `{EL_MODULE_BUILD_INFO}.Build_info`.

### Configuration Files

#### File: <project name>.ecf

Each project can have two equivalent Eiffel configuration files. One is in the standard [ECF](https://dev.eiffel.com/Configuration) XML format. The other is in the more readable [Pyxis](http://www.eiffelroom.com/node/527) format and has the extension [.pecf](http://www.eiffelroom.com/node/654#Gedit_Syntax_Highlighting). Either file can be used to build the project or open it in EiffelStudio. Use the following commands to convert from one to the other:

   el_toolkit -xml_to_pyxis -in [CONFIGURATION FILE]

   el_toolkit -pyxis_to_xml -in [CONFIGURATION FILE]

   el_toolkit -ecf_to_pecf -library_tree [DIRECTORY PATH]

#### File: project.py

This file is a Python script and is used to override default values for various environment variables and compile options for the [scons](http://www.scons.org/) build.
The following variables can be set.
* **major_version:** set major version number. This variable will appear in the Eiffel `BUILD_INFO` class.
* **minor_version:** set minor version number. This variable will appear in the Eiffel `BUILD_INFO` class.
* **installation_sub_directory:** set installation path for application relative to `/opt` in Unix and `%ProgramFiles%` in Windows. It doesn't matter whether you use the Windows or Unix path separator. This variable will appear in the Eiffel `BUILD_INFO` class.
* **environ**: this dictionary object defines the build shell environment. See section Build Environment for details.
* **MSC_options**: This sequence object contains options for the Microsoft C compiler.  See section *Microsoft C options*.

#### File: SConstruct

This is a file that the [scons](http://www.scons.org/) builder looks for in order to build a project. For Eiffel projects it contains the single line:

   import eiffel_loop.eiffel.SConstruct

#### Microsoft C options

To configure the Microsoft C compiler environment, edit the `MSC_options` variable in the `project.py`. Essentially these are arguments for the SetEnv.cmd command line tool.

By default `MSC_options` has the following values.

   MSC_options = ['/x64', '/xp' '/Release']

Note: if you set the cpu architecture option to be `/x86`, the 32bit version of EiffelStudio will be launched to compile the project. However if all you want to do is change the cpu architecture, it is better to do it with the `cpu=` command option for [scons](http://www.scons.org/) or launch_estudio. For example:

   scons cpu=x86 project=[PROJECT NAME] action=finalize

More about this in the Cross Compilation section.
### Cross Compilation
The eiffel_loop [scons](http://www.scons.org/) builder supports cross compilation. This feature is fully operational on Windows and partially completed under Unix. When doing finalized builds, an intermediate target is built under the build directory:

   build/F_code.tar.gz

This is a platform neutral archive of the generated C code under `EIFGENS/classic/F_code`. From this the final target is built in the `package/$ISE_PLATFORM/bin` directory. In Windows you can build a 64 bit binary of your application and then build a 32 bit version without having to do an Eiffel compilation. The 32 bit version is built with the command:

   scons cpu=x86 project=[PROJECT NAME] action=finalize

#### Requirements

To do cross compilation you must have a 64bit and a 32 bit version of EiffelStudio installed under these directories respectively.

   C:\Program files
   C:\Program files x86

If you wish to use the eiffel2python library, you need to have both the 64 bit and 32 bit version of Python installed.

## EXAMPLE APPLICATIONS

### Invoking Sub-applications

To simplify development, Eiffel-Loop has the concept of a multi-mode "Swiss Army Knife" application. Each individual sub-application inherits from class `EL_SUB_APPLICATION`, and the command line option is found by looking at the value implemented of attribute 'option_name'. When calling the application, this option name should be specified on the command line immediately after the executable command name.

   <command> -<option-name> [-logging]

Should the need arise for a more compact executable, it should be technically possible to designate each sub-application as the root class for an Eiffel project. Are alternatively just comment out the other sub-applications in the root manifest.

### Class APPLICATION_ROOT

Each project has a class `APPLICATION_ROOT` which inherits from `EL_MULTI_APPLICATION_ROOT`, and contains a manifest of all available sub-applications.
```` eiffel
class
   APPLICATION_ROOT

inherit
   EL_MULTI_APPLICATION_ROOT [BUILD_INFO]

create
   make

feature {NONE} -- Implementation

	Application_types: TUPLE [
      MY_FIRST_APP,
      MY_SECOND_APP
	]
     once
        create Result
     end
end
````
### Logging
Each sub-application has a minimum amount of terse log output. This output can be expanded with the addition of the `-logging` switch on the command line.
