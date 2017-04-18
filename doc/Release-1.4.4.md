# Eiffel-Loop as it was on the April 18th 2017

## BASE library

* Added function {EL_FILE_PATH}.modification_time_stamp

* Moved function `is_attached` from class `EL_MEMORY` to new class `EL_POINTER_ROUTINES`.

* Created new parent for class `EL_MEMORY`, `EL_DISPOSEABLE` which inherits `EL_POINTER_ROUTINES`.

* Fixed function `{EL_PROCEDURE}.same_procedure` for ES version 16.05

* Changed EL_LOG_MANAGER to work without inheriting `EL_SINGLE_THREAD_ACCESS` by enclosing shared instance in `EL_MUTEX_REFERENCE`

* added 4 new procedures to class `EL_ZSTRING`: `append_to`, `append_to_general`, `append_to_string_32`, `append_to_string_8`.

### IO output control

* Made output of lio object dependent on absence of command line switch `-silent`

* Made output of EL_MULTI_APPLICATION_ROOT application header information dependent on absence of both command line switches `-silent` and `-no_app_header`

* Added routines to class `EL_COMMAND_LINE_ARGUMENTS`: `has_silent`, `has_no_app_header`.

* Replaced `{EL_COMMAND_OPTIONS}.Console_on` with `Silent`. Added option: `no_app_header`

* Removed routine `{EL_MULTI_APPLICATION_ROOT}.Is_console_app`

## Scons build support
* New build option `compile_eiffel=no` forces a C only compilation using a previously compiled F_code tar. This tar is an intermediate build file found in the build directory. This is useful for recompiling a build with a different C compiler setting without having to do another Eiffel compile.

* New build option `MSC_options="..."` allows overriding of default `MSC_options` set in `project.py` (found in same directory as the ECF)

## C-LANGUAGE-INTERFACE library

* Revised C callback facility in class EL_C_CALLABLE. C callbacks into Eiffel are now made safe by first saving the result of `new_callback` to a local object before invoking the C routine which makes callbacks. After the routine has returned, call `release` on the callback object. This replaces the routines `protect_C_callback` and `unprotect_C_callback`.

## HTTP library

* Fixed class `EL_XML_HTTP_CONNECTION` so that GET and POST commands correspond to routines `read_xml_get` and `read_xml_post` respectively

* Fixed bug in `{EL_HTTP_CONNECTION}.set_post_data` where a copy of the string was not being maintained for cURL api.

* Added attribute `headers: EL_CURL_HEADER_TABLE` to `EL_HTTP_CONNECTION` for setting headers to send

* Set the Posix implementation to use the system installed development headers. Windows implementation relies on ES curl library headers.

* Added various support routines for SSL interactions.

## PAYPAL library

* Changed name of class `EL_PAYPAL_HTTP_CONNECTION` to `EL_PAYPAL_NVP_API_CONNECTION` and created new class `EL_PAYPAL_CONNECTION` which handles latest Paypal SSL verification requirements. 

### Class [EL_HTTP_CONNECTION](http://www.eiffel-loop.com/library/network/protocol/http/class-index.html#EL_HTTP_CONNECTION)

* Implemented the EL_HTTP_COMMAND objects for used read operations as reusable once variables.

## XDOC-SCANNING library

* Modified handler `{EL_EXPAT_XML_PARSER}.on_unknown_encoding` to manage any Windows or ISO-8859 encoding with the exception of `ISO-8859-12`

## VTD-XML library

* Changed all xpath and XML attribute name arguments to be of type `READABLE_STRING_GENERAL`.

* Added 7 routines which map an xpath specified node to an Eiffel attribute setting agent. They are named `set_$x` where `$x` is one of the type names: `boolean`, `integer`, `natural`, `string`, `string_8`, `string_32`. In all cases if the node is found, the setter agent is called with the node value. The can specify either an XML element or attribute.

* Added some missing routines for converting node values to type `BOOLEAN`

## VISION-2-X library

# Merged Windows and Unix implementation of `{EL_TEXT_RECTANGLE_IMP}.draw_rotated_on_buffer` and removed class `EL_TEXT_RECTANGLE_IMP`. Renamed `EL_TEXT_RECTANGLE_I` as `EL_TEXT_RECTANGLE`.
