# Eiffel-Loop as it was on the (to be decided)

(Version 1.4.7 has not yet been released)

## BASE library

* Added class `EL_PROCEDURE_TABLE`

* Merged `make_from_unicode` and `make_from_latin_1` into `make_from_general` in class `EL_READABLE_ZSTRING`. This allows for possibility that argument is of type `EL_ZSTRING`. Affects classes: `EL_STYLED_ZSTRING` `EL_ZSTRING` and `EL_MONOSPACED_STYLED_ZSTRING`.

* Merged `make_from_unicode` and `make_from_latin_1` into `make_from_general` in class `EL_PATH`

## XDOC-SCANNING library

* Added procedure `set_parser_type` to `EL_CREATEABLE_FROM_NODE_SCAN`

* Replaced anchored type definition `Type_building_actions` with class definition `EL_PROCEDURE_TABLE`.

* Changed `EL_SMART_BUILDABLE_FROM_NODE_SCAN` from being generic class to accepting a make routine argument of `TYPE [EL_PARSE_EVENT_SOURCE]`.

* Added deferred class EL_PYXIS_TREE_COMPILER

* Added routine: `{EL_CREATEABLE_FROM_NODE_SCAN}.build_from_lines`

* Added routine: `{EL_XML_NODE_SCAN_SOURCE}.apply_from_lines`

* Added routine: `{EL_XML_DOCUMENT_SCANNER}.scan_from_lines`

## DATABASE library

* The XML database in this library has been split off into a separate project `xml-database.ecf`. The original project has been renamed to `chain-db.ecf`.

## ENCRYPTION library

* Removed `EL_LOCALE_PASS_PHRASE` and the library `i18n.ecf` it depends on to prevent a dependency cycle.

* Changed class `EL_PASS_PHRASE` to used the deferred localization scheme via class `EL_MODULE_DEFERRED_LOCALE`

## WIN-INSTALLER library

* Maintenance to achieve library compilation

## WEL-X-AUDIO library

* Maintenance to achieve library compilation

## WAV-AUDIO library

* Renamed from audio-file.ecf

* Maintenance to achieve library compilation

## EROS-TEST-CLIENTS example

* Modified classes to use `{EL_CREATEABLE_FROM_NODE_SCAN}.set_parser_type`

* Maintenance to achieve library compilation

## EROS-SERVER example

* Modified classes to use `{EL_CREATEABLE_FROM_NODE_SCAN}.set_parser_type`

* Maintenance to achieve library compilation

## scons build system

* Fixed `eifel_loop.eiffe.ecf.EIFFEL_CONFIG` so that multiple references to the same ECF file are parsed only once.


