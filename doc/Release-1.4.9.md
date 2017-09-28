# Eiffel-Loop (1.4.9) for future release

## BASE library

* Added generic container class `EL_STRING_POOL` which serves as a pool of recyclable strings.

* Fixed case of encoding name constants in `EL_ENCODEABLE_AS_TEXT`.

* Added class `EL_CRC_32_ROUTINES` accessible via `EL_MODULE_CRC_32` with routines for finding and comparing cyclical redundancy check-sums of string lists.

* Added `encoding_change_actions: ACTION_SEQUENCE` to class `EL_ENCODEABLE_AS_TEXT` (triggered by call to `set_encoding`).  Set inherit status of `set_encoding` to frozen.

* Added routine `enable_shared_item` to class `EL_LINE_SOURCE` to cause only one instance of `EL_LINE_SOURCE.item` to be ever created during iteration.

* Introduced new class `EL_EVENT_LISTENER_LIST` to make possible a one-many event listener.

### Console Output

* Changed `lio` output object in `EL_MODULE_LIO` to automatically encode strings to match the console encoding setting. For EiffelStudio on Unix in work-bench mode, it will assume UTF-8 as a default if `LANG` is not set explicitly.

* Optimised detection of color change escape sequences in `lio` related objects.

* Optimised output of `STRING_8` and `STRING_32` strings

* Added new class `EL_CONSOLE_ENCODEABLE` for encoding strings to match console encoding setting.

## EVOLICITY library

* Added helper class `EVOLICITY_LOCALIZED_VARIABLES' to translate variable text-values which have a localisation translation id of the form "{$<variable-name>}".

## HTML-VIEWER library

* Updated agent syntax to 'simplified'.

## HTTP library

* Updated `EL_HTTP_CONNECTION` to have `user_agent' attribute. `open` now sets the user agent if it is not empty.

## IMAGE-UTILS library

* Fixed missing C include for file "c_eiffel_to_c.h".

## VISION2-X library

* Updated class `EL_MANAGED_WIDGET_LIST` to conform to `ARRAYED_LIST [EL_MANAGED_WIDGET [EV_WIDGET]]`

## TEST program

* Fixed path for `zlib.lib' for all dependencies in Windows implementation.



