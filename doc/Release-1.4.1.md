# Eiffel-Loop as it was on the 

## BASE library
* Fixed problem with `{EL_COMMAND_LINE_SUB_APPLICATION}.set_reference_operand` where only ZSTRING initialisation arguments were being read, and not STRING_8 or STRING_32 arguments
* Added a status attribute `has_bom` to `EL_LINE_SOURCE`. This is set from `make_latin` and `make_windows` with a call to `check_bom`. This fixes a problem where the presence of a BOM does not alter the encoding until after the first call to `start`.
* Added routine {EL_LINE_SOURCE}.open_at_start to open `source` in read mode and position the cursor either at 0 or after the BOM.
* Implemented `DEBUG_OUTPUT` for class `EL_READABLE_ZSTRING`

## EVOLICITY Library

* Added a new default template variable `$current` to context `EVOLICITY_SERIALIZEABLE'.

## TOOLKIT tool
* Created `EIFFEL_NOTE_EDITOR_TEST_SET` to test `EIFFEL_NOTE_EDITOR` and resolve some problems.
* Fixed problem with BOM being output on latin-1 source files in application `EIFFEL_NOTE_EDITOR_APP`
* Added `line_number` attribute to `EL_PLAIN_TEXT_LINE_STATE_MACHINE`. Incremented in the line processing loop

### Eiffel-View repository publisher
* Added ability for `EIFFEL_CLASS` to parse description notes using legacy syntax of Eiffel split-line strings as for example:
````
description: "This is a split%
    %line string"
````
* Added ability to add source tree descriptions to publisher configuration file. These descriptions can contain Eiffel-View markdown.
* Added ability to render bullet point markdown using asterisks at the beginning of lines.
* Now parses all note fields specified in configuration file. Only the description is output in the index page, but all the parsed fields are rendered at the top of the class source page.
* Provide a link at the top of the source page to allow quick navigation to the start of the class definition
* General class category on the site-map page are now pluralised.
* There is now an content index on homepage allowing quick navigation to major sections
* Changed configuration to assume for the source trees that all paths are relative to one specified as `root-dir`.
* If the version number has changed, then all the output directories will be removed
* Provides optional way to store source tree descriptions in a `.emd` file found in the configuration directory. `emd` stand for **e**iffel-v	iew **m**ark**d**own. File encoding is assumed to be UTF-8.
* Render words marked with double single ''quotes'' in italics.
* Configuration file format has been changed where possible to using element attributes in preference to text elements.
* Renamed Evolicity variable `is_index_page' to `is_site_map_page'
* Re-factored main template so that the Evolicity code for the site-map content and directory tree content are now in separate files.
* Re-factored main template so that the markup for favicons is now included by an Evolicity instruction.
* Introduced description dependency checking for directory tree pages using a checksum stored as a html meta field.
* Added an *ecf* attribute to tree elements in configuration file
* Site-map is also written as a github Contents.md
