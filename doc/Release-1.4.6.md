# Eiffel-Loop as it was on the (to be decided)

(Version 1.4.6 has not yet been released)

## BASE library

## XDOC-SCANNING library

* Simplified class `EL_XML_DOCUMENT_SCANNER' and it's descendants and clients by reducing number of creation routines to just one: `make (event_type: TYPE [EL_XML_PARSE_EVENT_SOURCE])`. Similarly reduced number of routines setting the `event_source` type.

* Introduced a new class `EL_EXPAT_XML_WITH_CTRL_Z_PARSER` to parse XML streams that are end delimited by Ctrl-z character.

* Renamed class `EL_XML_PARSE_EVENT_SOURCE` as `EL_PARSE_EVENT_SOURCE` since class `EL_PYXIS_PARSER` does not parse XML.

## TOOLKIT utility

* Changed class `PYXIS_TO_XML_CONVERTER` to add a namespace shorthand for Pyxis Eiffel Configuration files.
