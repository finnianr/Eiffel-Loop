
To build Soundbow and Hello_world programs requires the Macromedia Flash Profesional IDE Ver 8.x to compile the .fla files.
The accompanying ActionScript is version 2.0 so probably later versions of Flash won't work.

It is also necessary to download and compiles the sources for the Praat audio analyzer version <= 4.4.30. This is gcc
source code which must first be converted to compile with MS VC++. An Eiffel utility is provided to do this as part of
the Eiffel LOOP toolkit. The convertor makes a batch file which can then be used to create a static library which can
be linked in to the Eiffel application.
 
	Command line: 
		
		el_tools -praat_to_msvc -logging -source_dir <input-path>

(The convertor will not work with later versions because they use C99)

Tested: EiffelStudio 6.2, Visual C++ 2008 Express Edition, XP Pro SP2

May 16th 2009
There maybe some Eiffel compile errors as parts of the library have changed.


