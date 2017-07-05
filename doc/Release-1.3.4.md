Eiffel-Loop (1.3.4) released 25th June 2016

FEATURES AND IMPROVEMENTS

* Replaced all uses of bridge pattern based on `EL_CROSS_PLATFORM [I -> PLATFORM_IMPLEMENTATION]` with the attached implementation pattern:

```` eiffel
    local
       object: MY_CLASS_I
    do
       create {MY_CLASS_IMP} object.make
    end
````

* Improved framework for cross platform wrapping of OS commands and command line utilities.

 * Much improved class hierarchy design.
 * Error messages are now collected in string list.
 * Improved temporary file naming.
 * Better Windows encoding support with the use of the command prefix "cmd /U /C" to force UTF-16 output.
 * Addition of Autotest suite for all files commands.
 * New convenience class `EL_CAPTURED_OS_COMMAND` to collect output of any externally supplied command template as a string list

* Improvements to `EL_DIRECTORY` class for performance and usability

 * Recursive and non recursive search for files, directories or both by extension
 * Addition of status queries: has_file_name and has_executable

* Separated factory functions in class `EL_VISION_2_GUI_ROUTINES_I` into a separate factory class `EL_VISION_2_FACTORY` accessible from class `EL_MODULE_VISION_2`
    Addition of sub-application to el_toolkit to export emails from Thunderbird email client as a tree of HTML bodies.

And many other improvements and bug fixes
