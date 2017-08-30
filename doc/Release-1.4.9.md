# Eiffel-Loop (1.4.9) for future release

## BASE library

* Added generic container class `EL_STRING_POOL` which serves as a pool of recyclable strings.

* Fixed case of encoding name constants in `EL_ENCODEABLE_AS_TEXT`.

## EVOLICITY library

* Added helper class `EVOLICITY_LOCALIZED_VARIABLES' to translate variable text-values which have a localisation translation id of the form "{$<variable-name>}".

### Console Output

* Changed `lio` output object in `EL_MODULE_LIO` to automatically encode strings to match the console encoding setting. For EiffelStudio on Unix in work-bench mode, it will assume UTF-8 as a default if `LANG` is not set explicitly.

* Optimised detection of color change escape sequences in `lio` related objects.

* Optimised output of `STRING_8` and `STRING_32` strings

* Added new class `EL_CONSOLE_ENCODEABLE` for encoding strings to match console encoding setting.

## TEST program

* Fixed path for `zlib.lib' for all dependencies in Windows implementation.



