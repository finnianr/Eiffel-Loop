# Eiffel-Loop as it was on the (to be decided)

(Version 1.4.7 has not yet been released)

## APP-MANAGE library

* Refactored class `EL_COMMAND_LINE_SUB_APPLICATION` to use attribute `specs: ARRAYED_LIST [TUPLE [word_option, help_description: ZSTRING; is_required, path_exists: BOOLEAN]]`

* Replaced anchor type `like Type_argument_specification` with `like spec.item` in class `EL_COMMAND_LINE_SUB_APPLICATION`.

* Added argument construction routines `valid_optional_argument` and `valid_required_argument` for use in defining `argument_specs` array. These arguments accept a list of argument validation `PREDICATE` functions mapped to description string. If any predicate returns `False` the program exits and returns a message indicating an invalid argument.

* Sub-apps based on `EL_COMMAND_LINE_SUB_APPLICATION` can now print help with `-help` option.

* Changed type of all string arguments to query functions in `EL_COMMAND_LINE_ARGUMENTS` to type `READABLE_STRING_GENERAL`.

* Changed argument of {EL_APPLICATION_CONFIG_CELL}.make_from_option_name

* Changed many routines in `EL_SUB_APPLICATION' to accept string arguments of type `READABLE_STRING_GENERAL`

* Renamed `{EL_SUB_APPLICATION}.has_invalid_argument` to `has_argument_errors`

* Added possibility to report a list of argument errors rather than just one.

## BASE library

* Added class `EL_PROCEDURE_TABLE`

* Merged `make_from_unicode` and `make_from_latin_1` into `make_from_general` in class `EL_READABLE_ZSTRING`. This allows for possibility that argument is of type `EL_ZSTRING`. Affects classes: `EL_STYLED_ZSTRING` `EL_ZSTRING` and `EL_MONOSPACED_STYLED_ZSTRING`.

* Merged `make_from_unicode` and `make_from_latin_1` into `make_from_general` in class `EL_PATH`

* Added class `EL_DEFERRED_LOCALE_I' with global instance accessible via `EL_MODULE_DEFERRED_LOCALE'. These classes allow strings in module descendants to be optionally localized in an application by including `EL_MODULE_LOCALE' from the `i18n' library.

* Moved `remove_tail` and `remove_head` from `EL_PATH_STEPS` to `EL_ARRAYED_LIST`.

* Added routine `relative_steps_to (other: like Current): EL_PATH_STEPS` to class `EL_PATH`

* Added routines `substring_end' and `substring_start' to `ZSTRING'

* Fixed -help option for `EL_SUB_APPLICATION' to provide help for missing standard options.

* Added abstraction `EL_BUILDABLE_FROM_FILE`

* Made routine EL_STRING_X_ROUTINES.general_to_unicode obsolete

## DATABASE library

* The XML database in this library has been split off into a separate project `xml-database.ecf`. The original project has been renamed to `chain-db.ecf`.

## ENCRYPTION library

* Removed `EL_LOCALE_PASS_PHRASE` and the library `i18n.ecf` it depends on to prevent a dependency cycle.

* Changed class `EL_PASS_PHRASE` to used the deferred localization scheme via class `EL_MODULE_DEFERRED_LOCALE`

## I18N library

* Changed the stored locale data format from XML to binary. Each locale is now saved in a separate file `locale.x` where x is a 2 letter country code. See section `TOOLKIT tool` for new option to generate the data files.

## TOOLKIT tool
* Added new sub-application option `el_toolkit -compile_translations` to compile translation data files in binary format from Pyxis source. See class [./tool/toolkit/source/applications/pyxis/pyxis_translation_tree_compiler_app.e PYXIS_TRANSLATION_TREE_COMPILER_APP].

## WIN-INSTALLER library

* Maintenance to achieve library compilation

## WEL-X-AUDIO library

* Maintenance to achieve library compilation

## WAV-AUDIO library

* Renamed from audio-file.ecf

* Maintenance to achieve library compilation

## XDOC-SCANNING library

* Added procedure `set_parser_type` to `EL_CREATEABLE_FROM_NODE_SCAN`

* Replaced anchored type definition `Type_building_actions` with class definition `EL_PROCEDURE_TABLE`.

* Changed `EL_SMART_BUILDABLE_FROM_NODE_SCAN` from being generic class to accepting a make routine argument of `TYPE [EL_PARSE_EVENT_SOURCE]`.

* Added deferred class EL_PYXIS_TREE_COMPILER

* Added routine: `{EL_CREATEABLE_FROM_NODE_SCAN}.build_from_lines`

* Added routine: `{EL_XML_NODE_SCAN_SOURCE}.apply_from_lines`

* Added routine: `{EL_XML_DOCUMENT_SCANNER}.scan_from_lines`

## EROS-TEST-CLIENTS example

* Modified classes to use `{EL_CREATEABLE_FROM_NODE_SCAN}.set_parser_type`

* Maintenance to achieve library compilation

## EROS-SERVER example

* Modified classes to use `{EL_CREATEABLE_FROM_NODE_SCAN}.set_parser_type`

* Maintenance to achieve library compilation

## scons build system

* Fixed `eiffel_loop.eiffel.ecf.EIFFEL_CONFIG` so that multiple references to the same ECF file are parsed only once.


