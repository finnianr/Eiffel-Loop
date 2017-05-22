# Eiffel-Loop as it was on the (to be decided)

(Version 1.4.7 has not yet been released)

## BASE library

* Added class `EL_PROCEDURE_TABLE`

## XDOC-SCANNING library

* Added procedure `set_parser_type` to `EL_CREATEABLE_FROM_NODE_SCAN`

* Replaced anchored type definition `Type_building_actions` with class definition `EL_PROCEDURE_TABLE`.

* Changed `EL_SMART_BUILDABLE_FROM_NODE_SCAN` from being generic class to accepting a make routine argument of `TYPE [EL_PARSE_EVENT_SOURCE]`.

## EROS-TEST-CLIENTS example

* Modified classes to use `{EL_CREATEABLE_FROM_NODE_SCAN}.set_parser_type`

## EROS-SERVER example

* Modified classes to use `{EL_CREATEABLE_FROM_NODE_SCAN}.set_parser_type`


