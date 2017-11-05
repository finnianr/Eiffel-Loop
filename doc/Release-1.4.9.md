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

* Added routine `append_utf_8` to `EL_ZSTRING`

### Console Output

* Changed `lio` output object in `EL_MODULE_LIO` to automatically encode strings to match the console encoding setting. For EiffelStudio on Unix in work-bench mode, it will assume UTF-8 as a default if `LANG` is not set explicitly.

* Optimised detection of color change escape sequences in `lio` related objects.

* Optimised output of `STRING_8` and `STRING_32` strings

* Added new class `EL_CONSOLE_ENCODEABLE` for encoding strings to match console encoding setting.

## ENCRYPTION library

* Renamed preconditions `is_16_byte_blocks` as `count_multiple_of_block_size`

* Fixed `count_multiple_of_block_size` precondition for routine `{EL_AES_ENCRYPTER}.encrypted_managed`

## EVOLICITY library

* Added helper class `EVOLICITY_LOCALIZED_VARIABLES' to translate variable text-values which have a localisation translation id of the form "{$<variable-name>}".

## HTML-VIEWER library

* Updated agent syntax to 'simplified'.

## HTTP library

* Updated `EL_HTTP_CONNECTION` to have `user_agent' attribute. `open` now sets the user agent if it is not empty.

## LOGGING library

* Fixed bug where color escape sequences were being written to console by a logging thread that was not directed to the console.

## SERVLET library

* The dependency on the Goanna library for Fast CGI is now removed except for one trivial class found in `contrib/Eiffel/Goanna`.

* Implemented Fast-CGI protocol more efficiently than the Goanna library, with far fewer request generated objects for garbage collection. This implementation is based on the ISE network classes.

## IMAGE-UTILS library

* Fixed missing C include for file "c_eiffel_to_c.h".

## VISION2-X library

* Updated class `EL_MANAGED_WIDGET_LIST` to conform to `ARRAYED_LIST [EL_MANAGED_WIDGET [EV_WIDGET]]`

## THREAD library

* Reimplemented `EL_WORK_DISTRIBUTER` and `EL_WORK_DISTRIBUTION_THREAD` to use a mutex protected list of available thread indices.

* Added routine `wait_until` to `EL_SINGLE_THREAD_ACCESS`

* Added routine `locked` to `EL_MUTEX_REFERENCE`

* Renamed `EL_SUSPENDABLE_THREAD` to `EL_SUSPENDABLE` and removed inheritance from `EL_STATEFUL`. 

## EIFFEL program

* Updated Eiffel note editor to group note fields into three separated by a new line

## TEST program

* Fixed path for `zlib.lib' for all dependencies in Windows implementation.



