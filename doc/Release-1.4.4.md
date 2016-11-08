# Eiffel-Loop as it was on the XXX 2016

## BASE library
* Added function {EL_FILE_PATH}.modification_time_stamp
* Moved function `is_attached' from class `EL_MEMORY' to new class `EL_POINTER_ROUTINES'.
* Created new parent for class `EL_MEMORY', `EL_DISPOSEABLE' which inherits `EL_POINTER_ROUTINES'.

## C-LANGUAGE-INTERFACE library

* Revised C callback facility in class EL_C_CALLABLE. C callbacks into Eiffel are now made safe by first saving the result of `new_callback` to a local object before invoking the C routine which makes callbacks. After the routine has returned, call `release` on the callback object. This replaces the routines `protect_C_callback` and `unprotect_C_callback`.

## HTTP library

* Fixed class `EL_XML_HTTP_CONNECTION' so that GET and POST commands correspond to routines `read_xml_get` and `read_xml_post` respectively

### Class [EL_HTTP_CONNECTION](http://www.eiffel-loop.com/library/network/protocol/http/class-index.html#EL_HTTP_CONNECTION)

* Implemented the EL_HTTP_COMMAND objects for used read operations as reusable once variables.

## XDOC-SCANNING library

* Modified handler `{EL_EXPAT_XML_PARSER}.on_unknown_encoding` to manage any Windows or ISO-8859 encoding with the exception of `ISO-8859-12`

## VISION-2-X library

# Merged Windows and Unix implementation of `{EL_TEXT_RECTANGLE_IMP}.draw_rotated_on_buffer` and removed class `EL_TEXT_RECTANGLE_IMP`. Renamed `EL_TEXT_RECTANGLE_I` as `EL_TEXT_RECTANGLE`.
