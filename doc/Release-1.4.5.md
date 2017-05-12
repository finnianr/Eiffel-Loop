# Eiffel-Loop as it was on the 12th May 2017

## BASE library

* Added class `EL_URI_ROUTINES` with routines to parse uri's

* Changed `EL_URI_PATH` to use `EL_URI_ROUTINES`. Added routine `make_file` for initialisation from implicit paths.

* New cross-platform procedure `{EL_EXECUTION_ENVIRONMENT_I}.open_url` (accessible via EL_MODULE_EXECUTION)

* Added two new routines to class `EL_ZSTRING`: `append_all` and 'append_all_general'. These allow appending any container implementing INDEXABLE. This method of concatenation is more efficient than repeated appending calls, as sufficient area size is allocated before any appending takes place.

* Changed the feature `{EL_STATE_MACHINE}.final` from being a procedure to being an attribute of type `like: state`. Assigning the final machine state now requires the code line `line := state` instead of the previous `line := agent final`. This makes the state machine loop more efficient. Also, doing a freeze C compilation before running the code is no longer necessary.

* Add once routine '{EL_DATE_FORMATS}.Date_formats'

* Added function `groups (key: FUNCTION [ANY, TUPLE [G], ZSTRING]): EL_ZSTRING_HASH_TABLE [like Current]` to class `EL_ARRAYED_LIST`. It returns returns a table of item lists grouped by result of `key' function.

* Changed class `EL_PROCEDURE` to allow access to `closed_operands` of other `PROCEDURE`.

* Solved a DRY principle violation in functions `{EL_APPLICATION_PIXMAP}.svg_of_*` by making use of a factory object of type `EL_OBJECT_FACTORY [EL_SVG_PIXMAP]` in function `new_svg_pixmap`.

* Fixed bug in functions `{EL_APPLICATION_PIXMAP}.svg_of_*` where SVG's with an associated PNG file where not being rendered. A call to `update_png` was lacking.

* Added routine `append_step` to class `EL_PATH`.

* Fixed bug in routines `change_to_windows` and `change_to_unix` from class `EL_PATH` where a new instance of `parent_path` was not being created.

* Optimized operation of routine `set_parent_path` in class `EL_PATH` to minimize garbage collection

## VTD-XML library

* Added 4 more agent setter routines to class `EL_XPATH_NODE_CONTEXT`: `set_integer_64`, `set_natural_64`, `set_real` `set_double`. These map the value of a xpath specified node to an Eiffel field setting agent. The agent is called only if the node is found. The xpath can specify either an XML element or attribute.

## HTTP library

* Added class EL_WEB_ARCHIVE_HTTP_CONNECTION to find archived URL in the Wayback Machine using `wayback_url`

* Fixed a problem with routine `{EL_HTTP_CONNECTION}.read_string_head` where the body of the document was being fetched in addition to the headers.

* Fixed a problem of unwanted information being displayed in the console during calls to `{EL_HTTP_CONNECTION}.read_string_head`.

* Fixed problem of using global instance of `EL_HTTP_CONNECTION` when fetching headers

* Fixed assertions for test `{HTTP_CONNECTION_TEST_SET}.test_image_headers`

## OS-COMMAND library

* Removed `-f` option from `sendmail` command in class `EL_SEND_MAIL_COMMAND_IMP`. It was causing a long delay.

## VISION-2-X library

* Added a new class `EL_BOOLEAN_ITEM_RADIO_BUTTON_GROUP` for inputting binary options with radio buttons

* Added procedures `set_default_date_format` and `set_date_format` to class `EL_SCROLLABLE_SEARCH_RESULTS`. If the result item conforms to `EL_DATEABLE`, then the date is displayed in the search result items using the format specified by `date_format`. If `date_format` is empty, then the date is not displayed

* Added procedure `set_text_wrapped_to_width_cms` to class `EL_LABEL`. Changed `make_with_text` to allow initialization from ZSTRING's.

* Changed `new_wrapped_text_rectangle (a_text: ZSTRING): EL_TEXT_RECTANGLE` in class `{EL_WORD_WRAPPABLE}` to allow for the possibility that `a_text` might contain new lines. Made a related changed to function `{EL_VISION_2_GUI_ROUTINES_I}.is_word_wrappable`

* Added routine `make_default` to `EL_LABEL`.


