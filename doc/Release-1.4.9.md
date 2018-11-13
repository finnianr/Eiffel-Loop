# Eiffel-Loop (1.4.9) for future release

## APP MANAGE library

* Added ability to `EL_COMMAND_LINE_SUB_APPLICATION` to map command line argument to make routine operand of type `EL_ENVIRON_VARIABLE`.

* Added classes `EL_DIR_PATH_ENVIRON_VARIABLE` and `EL_FILE_PATH_ENVIRON_VARIABLE`

* Routines `default_operands` and `make_action` from class `EL_COMMAND_LINE_SUB_APPLICATION`, are now conflated into one routine `default_make`.

* Added new abstractions: `EL_WRITEABLE` and `EL_READABLE` and changed a number of existing classes to use them. See Eiffel user group article: [The missing abstractions: READABLE and WRITEABLE](https://groups.google.com/forum/#!topic/eiffel-users/7LrzqAZ4WzA)

* Removed dependency on EL logging library `logging.ecf` so developers preferred logging library can be used.

## BASE library

* Added the routines `push_cursor` and `pop_cursor` to class `EL_CHAIN` to make the saving and restoring of the cursor position both more efficient and more convenient. This is especially true for the implementation in class `EL_ARRAYED_LIST` as no `CURSOR` objects are created.

* Added the routine `shift_i_th` to `EL_ARRAYED_LIST` allowing you to shift the position of items in either direction by an `offset` argument.

* Added generic container class `EL_STRING_POOL` which serves as a pool of recyclable strings.

* Added class `EL_CRC_32_ROUTINES` accessible via `EL_MODULE_CRC_32` with routines for finding and comparing cyclical redundancy check-sums of string lists.

* Added routine `enable_shared_item` to class `EL_LINE_SOURCE` to cause only one instance of `EL_LINE_SOURCE.item` to be ever created during iteration.

* Introduced new class `EL_EVENT_LISTENER_LIST` to make possible a one-many event listener.

* Created new class `EL_ENVIRON_VARIABLE` for defining environment arguments.

### Class EL_ENCODEABLE_AS_TEXT

* Redesigned this class for greater efficiency by storing both encoding type and encoding id in one INTEGER attribute: `internal_encoding`.

* To solve a particular problem added `encoding_change_actions: ACTION_SEQUENCE` to class `EL_ENCODEABLE_AS_TEXT` (triggered by call to `set_encoding`).  Set inherit status of `set_encoding` to frozen.

### Class EL_OUTPUT_MEDIUM

* Refactored to inherit `EL_WRITEABLE`

* To be consistent in Eiffel-Loop naming conventions, renamed `put_string` to `put_string_general` and `put_string_z` as `put_string`.

* Optimised string encoding conversion by removing the need to create temporary strings

* Simplified code with the introduction of codec class `EL_UTF_8_ZCODEC`

### Class EL_ZCODEC (and related)

* Refactored to inherit `EL_ENCODEABLE_AS_TEXT` initialised from class `generator`

* Added new descendant `EL_UTF_8_ZCODEC`

* Simplified class `EL_ZCODEC_FACTORY` (renamed from `EL_SHARED_ZCODEC_FACTORY`) by merging Windows and Latin routines.

### Class EL_ZSTRING

* Added routines: `append_utf_8` and `append_to_utf_8`

* Added routine `to_canonically_spaced` and `as_canonically_spaced`

* Added routine `write_latin` to write `area` sequence as raw characters to `writeable`

### Reflection Classes

Created a set of reflection classes that can be directly inherited by class to obtain the following benefits:

* Automatic object initialisation for basic types including strings, and types conforming to `EL_MAKEABLE_FROM_STRING`.

* Object field attribute setting from name value string pairs, with the facility to adapt foreign naming conventions: camelCase, kebab-case, etc.

* Object field attribute string value querying from name strings, with the facility to adapt foreign naming conventions: camelCase, kebab-case, etc.

### Console Output

* Changed `lio` output object in `EL_MODULE_LIO` to automatically encode strings to match the console encoding setting. For EiffelStudio on Unix in work-bench mode, it will assume UTF-8 as a default if `LANG` is not set explicitly.

* Optimised detection of color change escape sequences in `lio` related objects.

* Optimised output of `STRING_8` and `STRING_32` strings

* Added new class `EL_CONSOLE_ENCODEABLE` for encoding strings to match console encoding setting.

## BASE library (data_structure)

### New class EL_ARRAYED_MAP_LIST
Added a new container class with about a dozen features defined as:
```eiffel
class
   EL_ARRAYED_MAP_LIST [K -> HASHABLE, G]

inherit
   EL_ARRAYED_LIST [TUPLE [key: K; value: G]]
      rename
         extend as map_extend
      end

create
   make, make_filled, make_from_array, make_empty, make_from_table
```
There is also a sortable descendant defined as:
```eiffel
EL_SORTABLE_ARRAYED_MAP_LIST [K -> {HASHABLE, COMPARABLE}, G]
```
See class [AIA_CANONICAL_REQUEST](http://www.eiffel-loop.com/library/network/amazon/authorization/aia_canonical_request.html) for an example.

### Class EL_STRING_HASH_TABLE

Added a `+` aliased routine that allows table extension using a syntax illustrated by this code example:
```eiffel
getter_function_table: EL_STRING_HASH_TABLE
      --
   do
      Result := Precursor +
         ["audio_id", agent: STRING do Result := audio_id.out end] +
         ["artists", agent: ZSTRING do Result := Xml.escaped (artists_list.comma_separated) end]
   end
```

### New class EL_STORABLE_LIST
This class is very useful when used in conjunction with the [Chain-DB database library](http://www.eiffel-loop.com/library/persistency/database/chain-db/class-index.html). It allows you to make auto-indexing data records by over-riding the function `new_index_by: TUPLE`. Here is an example:
```eiffel

deferred class
   CUSTOMER_LIST

inherit
   EL_REFLECTIVELY_STORABLE_LIST [CUSTOMER]

feature {NONE} -- Factory

   new_index_by: TUPLE [email: like new_index_by_string]
      do
         Result := [new_index_by_string (agent {CUSTOMER}.email)]
      end
```
Because the function returns a `TUPLE` you can define an arbitrary number of field indexes. The function `new_index_by_string` returns a type `EL_STORABLE_LIST_INDEX` which is basically a hash table. Instances of this class allow you move the cursor in the parent table by searching for a field key of a storable object.

There is also an auxiliary class [`EL_KEY_INDEXABLE`](http://www.eiffel-loop.com/library/base/data_structure/list/el_key_indexable.html) which when also inherited by the list provides an auto-indexing primary key if the list class parameter conforms to `EL_KEY_IDENTIFIABLE_STORABLE`. This primary-key index is accessible as `index_by_key` and conforms to `EL_STORABLE_LIST_INDEX`. The generation of primary keys is also handled by this class.

The above example shows a descendant class `EL_REFLECTIVELY_STORABLE_LIST` which allows you to reflectively export to CSV files provided that the list parameter conforms to `EL_REFLECTIVELY_SETTABLE_STORABLE`.

### Extensions to EL_CHAIN

Added many new query routines to class `EL_CHAIN`

## ENCRYPTION library

* Renamed preconditions `is_16_byte_blocks` as `count_multiple_of_block_size`

* Fixed `count_multiple_of_block_size` precondition for routine `{EL_AES_ENCRYPTER}.encrypted_managed`

* Renamed `EL_PASS_PHRASE` as `EL_AES_CREDENTIAL` and `EL_BUILDABLE_PASS_PHRASE` as `EL_BUILDABLE_AES_CREDENTIAL`

## EVOLICITY library

* Added helper class `EVOLICITY_LOCALIZED_VARIABLES` to translate variable text-values which have a localisation translation id of the form "{$<variable-name>}".

## HTML-VIEWER library

* Updated agent syntax to 'simplified'.

## HTTP library

* Updated `EL_HTTP_CONNECTION` to have `user_agent` attribute. `open` now sets the user agent if it is not empty.

## IMAGE-UTILS library

* Fixed missing C include for file "c_eiffel_to_c.h".

## LOGGING library

* Fixed bug where color escape sequences were being written to console by a logging thread that was not directed to the console.

## NETWORK library

* Changed `EL_NETWORK_STREAM_SOCKET` to redefine `make_empty` instead of `make`

* Created class `EL_UNIX_STREAM_SOCKET` inheriting `EL_STREAM_SOCKET`.

## OS-COMMAND library

* Fixed `{EL_OS_COMMAND_I}.new_temporary_file_path` to produce unique file names for the same command.

* Optimised number of objects created when calling `{EL_OS_COMMAND_I}.new_temporary_file_path`

* Added class `EL_FILE_MANIFEST_COMMAND` for creating XML manifest of a directory.

## SEARCH-ENGINE library

Refactored library to use `EL_QUERY_CONDITION` class and the function `{EL_CHAIN}.query`

## SERVLET library

* Removed dependency on the Goanna library for FastCGI services.

* Created a better designed and more efficient Fast-CGI service to replace the previously used one from the Goanna library. It has far fewer request generated objects for garbage collection, and uses the ISE network classes instead of the ones in Eposix.

* Fixed orderly shutdown with Ctrl-C

## THREAD library

* Reimplemented `EL_WORK_DISTRIBUTER` and `EL_WORK_DISTRIBUTION_THREAD` to use a mutex protected list of available thread indices.

* Added routine `wait_until` to `EL_SINGLE_THREAD_ACCESS`

* Added routine `locked` to `EL_MUTEX_REFERENCE`

* Renamed `EL_SUSPENDABLE_THREAD` to `EL_SUSPENDABLE` and removed inheritance from `EL_STATEFUL`. 

## VISION2-X library

* Updated class `EL_MANAGED_WIDGET_LIST` to conform to `ARRAYED_LIST [EL_MANAGED_WIDGET [EV_WIDGET]]`

## XDOX-SCANNING library

* Added a class `EL_SETTABLE_FROM_XML_NODE` than can be used in conjunction with `EL_REFLECTIVELY_SETTABLE` to build Eiffel objects from XML documents that have element names corresponding to field attributes. The XML names may use a different word joining convention. See class `RBOX_IRADIO_ENTRY` and it's descendants from the example project `manage-mp3.ecf`.

## EIFFEL program

* Updated Eiffel note editor to group note fields into three separated by a new line

* Added a new tool to `el_toolkit` for downloading youtube UHD videos. See news group [article](https://groups.google.com/forum/#!topic/eiffel-users/DZHqE7EO3Ww)

## TEST program

* Fixed path for `zlib.lib` for all dependencies in Windows implementation.


