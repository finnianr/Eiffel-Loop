# Eiffel-Loop (1.4.9) for future release

## APP MANAGE library

* Added ability to `EL_COMMAND_LINE_SUB_APPLICATION` to map command line argument to make routine operand of type `EL_ENVIRON_VARIABLE`.

* Added classes `EL_DIR_PATH_ENVIRON_VARIABLE` and `EL_FILE_PATH_ENVIRON_VARIABLE`

* Routines `default_operands' and `make_action' from class `EL_COMMAND_LINE_SUB_APPLICATION`, are now conflated into one routine `default_make'.

## BASE library

* Added generic container class `EL_STRING_POOL` which serves as a pool of recyclable strings.

* Fixed case of encoding name constants in `EL_ENCODEABLE_AS_TEXT`.

* Added class `EL_CRC_32_ROUTINES` accessible via `EL_MODULE_CRC_32` with routines for finding and comparing cyclical redundancy check-sums of string lists.

* Added `encoding_change_actions: ACTION_SEQUENCE` to class `EL_ENCODEABLE_AS_TEXT` (triggered by call to `set_encoding`).  Set inherit status of `set_encoding` to frozen.

* Added routine `enable_shared_item` to class `EL_LINE_SOURCE` to cause only one instance of `EL_LINE_SOURCE.item` to be ever created during iteration.

* Introduced new class `EL_EVENT_LISTENER_LIST` to make possible a one-many event listener.

* Created new class `EL_ENVIRON_VARIABLE` for defining environment arguments.

### Class EL_ZSTRING

* Added routines: `append_utf_8` and `append_to_utf_8`

* Added routine `to_canonically_spaced` and `as_canonically_spaced`

### Reflection Classes

Created a set of reflection classes that offering a number of facilites:

* Automatic object initialisation for basic types including strings, and types conforming to `EL_MAKEABLE_FROM_STRING'.

* Object field attribute setting from name value string pairs, with the facility to adapt foreign naming conventions: camelCase, kebab-case, etc.

* Object field attribute string value querying from name strings, with the facility to adapt foreign naming conventions: camelCase, kebab-case, etc.



### Console Output

* Changed `lio` output object in `EL_MODULE_LIO` to automatically encode strings to match the console encoding setting. For EiffelStudio on Unix in work-bench mode, it will assume UTF-8 as a default if `LANG` is not set explicitly.

* Optimised detection of color change escape sequences in `lio` related objects.

* Optimised output of `STRING_8` and `STRING_32` strings

* Added new class `EL_CONSOLE_ENCODEABLE` for encoding strings to match console encoding setting.

## ENCRYPTION library

* Renamed preconditions `is_16_byte_blocks` as `count_multiple_of_block_size`

* Fixed `count_multiple_of_block_size` precondition for routine `{EL_AES_ENCRYPTER}.encrypted_managed`

* Renamed `EL_PASS_PHRASE` as `EL_AES_CREDENTIAL` and `EL_BUILDABLE_PASS_PHRASE` as `EL_BUILDABLE_AES_CREDENTIAL`

## EVOLICITY library

* Added helper class `EVOLICITY_LOCALIZED_VARIABLES' to translate variable text-values which have a localisation translation id of the form "{$<variable-name>}".

## HTML-VIEWER library

* Updated agent syntax to 'simplified'.

## HTTP library

* Updated `EL_HTTP_CONNECTION` to have `user_agent' attribute. `open` now sets the user agent if it is not empty.

## IMAGE-UTILS library

* Fixed missing C include for file "c_eiffel_to_c.h".

## LOGGING library

* Fixed bug where color escape sequences were being written to console by a logging thread that was not directed to the console.

## NETWORK library

* Changed EL_NETWORK_STREAM_SOCKET to redefine `make_empty` instead of `make`

* Created class `EL_UNIX_STREAM_SOCKET` inheriting `EL_STREAM_SOCKET`.

## OS-COMMAND library

* Fixed `{EL_OS_COMMAND_I}.new_temporary_file_path` to produce unique file names for the same command.

* Optimised number of objects created when calling `{EL_OS_COMMAND_I}.new_temporary_file_path`

## SERVLET library

* Removed dependency on the Goanna library for FastCGI services.

* Created a better designed and more efficient Fast-CGI service to replace the previously used one from the Goanna library. It has far fewer request generated objects for garbage collection, and uses the ISE network classes instead of the ones in Eposix.

* Fixed orderly shutdown with Ctrl-C

## THREAD library

* Reimplemented `EL_WORK_DISTRIBUTER` and `EL_WORK_DISTRIBUTION_THREAD` to use a mutex protected list of available thread indices.

* Added routine `wait_until` to `EL_SINGLE_THREAD_ACCESS`

* Added routine `locked` to `EL_MUTEX_REFERENCE`

* Renamed `EL_SUSPENDABLE_THREAD` to `EL_SUSPENDABLE` and removed inheritance from `EL_STATEFUL`. 

## VISION2-X library

* Updated class `EL_MANAGED_WIDGET_LIST` to conform to `ARRAYED_LIST [EL_MANAGED_WIDGET [EV_WIDGET]]`

## XDOX-SCANNING library

* Added a class `EL_SETTABLE_FROM_XML_NODE` than can be used in conjunction with `EL_REFLECTIVELY_SETTABLE' to build Eiffel objects from XML documents that have element names corresponding to field attributes. The XML names may use a different word joining convention. See class `RBOX_IRADIO_ENTRY` and it's descendants from the example project `manage-mp3.ecf`.

## EIFFEL program

* Updated Eiffel note editor to group note fields into three separated by a new line

## TEST program

* Fixed path for `zlib.lib' for all dependencies in Windows implementation.



