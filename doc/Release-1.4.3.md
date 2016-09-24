# Eiffel-Loop as it was on the 24th September 2016

## BASE library
* Added class `EL_COLON_FIELD_ROUTINES` accessible through class `EL_MODULE_COLON_FIELD`. Used to parse colon delimited fields in file line.

* Created class `EL_COMMAND_MENU` for use with `EL_COMMAND_SHELL`. This class displays a command menu using columns with a maximum of 10 rows in each.

* Fixed recursion bug in `{EL_READABLE_ZSTRING}.substring_between_general`

* Added new class `EL_NAME_VALUE_PAIR` to parse strings that use a character like ':' to indicate a named string value.
* Added new class `EL_JSON_NAME_VALUE_PAIR` based on `EL_NAME_VALUE_PAIR`.

## LOG library
* Added `redirect_output_to_console (thread: EL_IDENTIFIED_THREAD_I)` to class `EL_LOG_MANAGER`

## HTTP library

* Fixed the problems identified in this [code review](https://groups.google.com/forum/#!topic/eiffel-users/5rXQC2sQNZU) of the ISE library `cURL` by creating a new Eiffel C API interface to libcurl.
* Fixed class EL_HTTP_COOKIES so it can decode UTF-8 values like `"K\303\266ln-Altstadt-S\303\274d"`
* Added download progress monitoring via class `EL_SHARED_FILE_PROGRESS_LISTENER`
* Created an AutoTest suite `HTTP_CONNECTION_TEST_SET` to test the most common `EL_HTTP_CONNECTION` operations.

### Class EL_HTTP_CONNECTION

* Removed the dependency on class `CURL_EASY_EXTERNALS` from library cURL
* Changed cookie handling to allow for the possibility of using separate file for loading and storing HTTP cookies.
* Added new routine `download` for downloading data directly to a file.
* Added routine `read_string_head` to execute a HTTP HEAD command making the result available in `last_string`. Useful for reading HTTP headers associated with a file without having to download a file.
* Added routine `read_string_post` to execute a HTTP POST command making the result available in `last_string`.
* Added routine `read_string_get` to execute a HTTP GET command making the result available in `last_string`.
* Added new function `last_headers: EL_HTTP_HEADERS` that parses the `last_string` result of a `read_string_head` command.

## OS-COMMAND library
* Removed `is_asynchronous` from `EL_OS_COMMAND_I` because it was a bad idea that lead to problems.
* Create an new abstract class `EL_EMAIL` for use with class `EL_SEND_MAIL_COMMAND_I`.

## TOOLKIT utility

### Eiffel-View

* The Eiffel-View source code publisher now outputs library sub-categories based sub-directory names under ''library''. This greatly improves the usefulness of the document fragment index at the top of the sitemap page. Also in the directory index page, "library" is now prefixed by the sub-category name.
