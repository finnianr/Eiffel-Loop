# Eiffel-Loop as it was on the 20th May 2017

## BASE library

* A new class `EL_GROUP_TABLE` for grouping items in an indexable list according to a grouping function specified in the creation routine.

* Simplified `EL_PATH_STEPS` to make use of `EL_ZSTRING_LIST` and simplified conversion directions. Changed `make_from_array` to accept an argument of type `INDEXABLE [READABLE_STRING_GENERAL, INTEGER]`.

* Added class `EL_ZSTRING_ROUTINES` accessible through `EL_MODULE_ZSTRING`. Routine `as_zstring (str: READABLE_STRING_GENERAL): ZSTRING` converts any string to a ZSTRING.

* Optimised `EL_MATCH_ALL_IN_LIST_TP` and related classes, to save and restore cursor positions using index rather than cursor, as the latter requires object creation.

## THREAD library

* Added two descendants of class `EL_WORK_DISTRIBUTER`, namely `EL_FUNCTION_DISTRIBUTER` and `EL_PROCEDURE_DISTRIBUTER`. These classes make it easier to work with distributed execution of routines.

## XDOC-SCANNING library

* Simplified class `EL_XML_DOCUMENT_SCANNER` and it's descendants and clients by reducing number of creation routines to just one: `make (event_type: TYPE [EL_XML_PARSE_EVENT_SOURCE])`. Similarly reduced number of routines setting the `event_source` type.

* Introduced a new class `EL_EXPAT_XML_WITH_CTRL_Z_PARSER` to parse XML streams that are end delimited by Ctrl-z character.

* Renamed class `EL_XML_PARSE_EVENT_SOURCE` as `EL_PARSE_EVENT_SOURCE` since class `EL_PYXIS_PARSER` does not parse XML.

## TOOLKIT utility

* Changed class `PYXIS_TO_XML_CONVERTER` to add a namespace shorthand for Pyxis Eiffel Configuration files.

## TEST project

* Added class `TEST_WORK_DISTRIBUTER_APP` to test the working of classes `EL_FUNCTION_DISTRIBUTER` and `EL_PROCEDURE_DISTRIBUTER`
