# Eiffel-Loop (20.1.0) 2nd January 2020

## Preface

Since version 1.4.8 Eiffel-loop has expanded with the addition of 587 new classes and existing classes have seen extensive improvements and fixes.
Unfortunately there have been too many changes and new additions to document exhaustively. The best I could do is to append a copy of the commit log produced with the command.

```
git --no-pager log --after='2017-08-14 23:50:00' --pretty=format:'%s' --author='Finnian' | sort
```
See *Commmit Log Index* below

Note that with this release the version number scheme has changed, and the major version number now denotes the year of release.

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

## Commmit Log Index

Abbreviated EL_PAYPAL_ to PP_
Add curly brace variables to EL_TEMPLATE
Added ability to output collections of basic types to EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML
Added attribute non_conforming_list to class EL_TUPLE_TYPE_LIST
Added class count to repository publisher
Added class EL_DESELECTABLE_WIDGET and EL_CHECK_BUTTON
Added class el_opf_manifest_list.e
Added class EL_ZSTRING_APPEND_ROUTINES and EL_STRING_8
Added class EVOLICITY_TUPLE_CONTEXT and class EL_TUPLE_TYPE_ARRAY
Added class EXPORT_TO_DEVICE_TASK to manage-mp3.ecf
Added default values to help_table of EL_COMMAND_LINE_OPTIONS
Added EL_DATE_INPUT_BOX
Added EL_DATE_INPUT widget and generalized EL_INPUT_FIELD
Added {EL_MODEL_ROTATED_PICTURE}.is_mirrored
Added exit_code to EL_SUB_APPLICATION for batch testing
Added function m3u_entry to RBOX_SONG
Added line to setup.sh to build and install MTeiffel_curl.o
Added ordering conversion routines to EL_CHAIN
Added progress bar for ftp upload of published playlists
Added routine flip to class EL_DRAWABLE_PIXEL_BUFFER with or'd flip state
Added routines to EL_CHAIN for query, mapping, summation and string conversion
Added script build_c_library.py to tools and changed {ZSTRING}.to_unicode to return general string
Added script ec_write_set_environ.py and fixed ec_build_finalized.py for Windows
Added test suite SETTABLE_FROM_JSON_STRING_TEST_SET
Added toolkit app FILE_TREE_TRANSFORM_SCRIPT_APP and class EL_FILE_TREE_TRANSFORMER
Added utility CLASS_DESCENDANTS_APP
Added XDG menu entry writing to EL_DEBIAN_PACKAGER
Add function list_operand to EL_DIRECTORY
Addition of class EL_TEST_SET_BRIDGE
Additions to documentation
Additions to documentation
Add library text-formats.ecf
Add set_path_name to el_info_raw_file
Add transfer-sync folder to EL_base library
Adjustment for node scanning library
Adjustments to vision-2-x extensions structure
Adjust structure Vision2-x extensions
AIA api substantially finished
Allow publisher config ecf form: library/base/base.ecf#runtime
Applied EL_CACHE_TABLE in 9 places
Applied shared tl_string to more TagLib classes
Base class for shared once strings EL_SHARED_ONCE_STRING_GENERAL
Better numeric conversion scheme for class EVOLICITY_COMPARISON
cached `sink_except' field exclusions in class EL_CLASS_META_DATA
Changed argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
Changed class AIA_SHARED_CREDENTIAL_LIST to use EL_CONFORMING_SINGLETON
Changed description of testing.pecf
Changed EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION to print failures at the end
Changed EL_IP_ADAPTER_INFO_COMMAND_IMP to parse output of nmcli instead of nm-tools
Changed {EL_SUSPENDABLE}.resume
Changed {FCGI_HEADER_RECORD}.record_type to return a default for unimplemented record types
Changed location of locale data files
Changed Python class EIFFEL_PROJECT to update both ecf and pecf project files
Changed spec implementations to imp_unix and imp_mswin
Changed Thunberbird HTML body export to use EL_STRING_EDITOR
Change implemenation of EL_CHAIN.append for iterable containers
Changes to documentation config
Changes to EL_COMMAND_LINE_SUB_APPLICATION descendants
Changes to EL_PATH implemenation
Changes to find_first and find_next in EL_CHAIN
Changes to reflection system to eliminate need for centralized manager
Changes to shared exchange rate class names
Changes to TEST_WORK_DISTRIBUTER_APP to demo Ctrl-C cancelation
Change to EL_WORK_DISTRIBUTION_THREAD
Change type of Except_fields to STRING
class EL_DRAWABLE_PIXEL_BUFFER simplified by use of EL_ORIENTATION_CONSTANTS
Class EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML tested and ready for action
Class renames in toolkit.ecf
Copy scripts for Debian Package generation
Create class EL_COMMA_SEPARATED_WORDS_LIST to store words from EL_WORD_TOKEN_TABLE
Created abstraction el_location_cache_table
Created class EL_COMMAND_LINE_OPTIONS for reflective command line reading
Created class EL_DIRECTORY_ITERATION_CURSOR do simplify many routines in EL_DIRECTORY
Created class EL_EQA_TEST_SET_EVALUATOR with demo in test.ecf
Created class EL_FILE_PERSISTENT_I and changed autotest evaluator_types
Created class EL_TEMPLATE in base
Created class TL_MPEG_FILE and updated indexing notes of many
Created cpp_conform_to tests for TagLib
Created EL_CPP_STD_ITERATION_CURSOR, EL_CPP_ITERATION_CURSOR for use in ID3 tagging libraries
Created EL_FILE_MANIFEST_LIST in xmldoc-scanning.ecf
Created EL_LOCALIZED_THUNDERBIRD_BOOK_EXPORTER and added status query routines to EL_ZSTRING
Created EL_PROGRESS_BUTTON [B -> EV_BUTTON]
Created enumeration for TagLib picture types
Created enumeration of ID3 frame code for TabLib.ecf
Created EVOLICITY_REFLECTIVE_EIFFEL_CONTEXT and refactored node scanning classes
Created MANAGEMENT_TASK hierarchy in project manage-mp3.ecf
Created part_string in EL_PATH and EL_PATH_URI
Created PP_SHARED_CONFIGURATION for Paypal API
Created progress tracker separate from file progress tracker
Created Python package eiffel_loop.eiffel.ise
Created TASK_CONFIG for Rhythmbox manager
Create EL_INPUT_PATH and restructured eiffel.ecf sources
Create EL_RESOURCE_INSTALL_MANAGER in app-manage.ecf
Create EL_SINGLETON class
Create EL_TUPLE_ROUTINES and shared access
Debian packaging
Decoupled EL_COMMAND_LINE_ARGUMENTS from EL_COMMAND_LINE_SUB_APPLICATION and moved to base.ecf
Documentation update
Documentation updates including fix to descendants eiffel tool
EL_DIGEST_ARRAY now inherits from EL_BYTE_ARRAY, reorganised base class locations
EL_DIRECTORY_ITERATION_CURSOR no longer uses {EL_DIRECTORY}.make_open_read
EL_HASH_SET now inherits TRAVERSABLE_SET which inherits SET
EL_PATH now uses a temporary path and make takes general string
Filtered nmcli to GENERAL field in class EL_IP_ADAPTER_INFO_COMMAND_I
Finished implementation location normalizer and fixed Python build to find build_info.e
Finished work on duplicity restore
finnianr
First run of IL_MPEG_FILE and introduce EL_OWNED_C_OBJECT
First use of EL_BUILDER_OBJECT_FACTORY [MANAGEMENT_TASK]
Fixed bug with EL_MODEL_BUFFER_PROJECTOR drawing of rotatable picture
Fixed class EL_JSON_NAME_VALUE_LIST so that unquoted JSON values can be parsed
Fixed date note fields on Eiffel sources and scons build system to use ecf version
Fixed double close problem on ECD_EDITIONS_FILE
Fixed EL_DIRECTORY dispose bug on final collect
Fixed EL_EQA_TEST_SET_EVALUATOR do_test to use anchored argument
Fixed EL_FTP_SYNC to update sync table only when item successfully synced
Fixed el_model_buffer_projector rendering of rotated pictures
Fixed EL_REFLECTED_BOOLEAN_REF when using aliases for true/false
Fixed FCGI_SERVLET_RESPONSE to return status code
Fixed generation of Contents.md in repository publisher
Fixed issue of C library dependencies not being built for finalized builds
Fixed issue of consistent current_digest in LIBRARY_CLASS
Fixed python script meta fields
Fixed reading of version in Python class EIFFEL_PROJECT
Fixed SEARCH_ENGINE_TEST_EVALUATOR to use new EL_WORD_TOKEN_LIST
Fixed synchronous execution for EL_WORK_DISTRIBUTER
Fixed tests not appearing in generated html of Eiffel-View publisher
Fixed "The following tests failed"
Fixed update of published page when deleted in repositor publisher
Fixed XML escaping bug for character entity
Fix for FastCGI HEAD request problem
Fix to call eiffel_loop.scripts.ec_build_finalized.py from setup.py
Fix to ECD_LIST_INDEX and made EL_PROCEDURE_TABLE generic
Fractal fully configurable from Pyxis
Implemented basic TabLib library frame types
Improved FCGI header handling
Improvements to class derived naming routines in class EL_NAMING_ROUTINES
Improvements to EL_BENCHMARK_COMMAND_SHELL
Improvements to youtube download sub-application
Improvements to youtube download sub-application
Introduced class EL_FILE_SYNC_ITEM for repository publisher
Introduced EL_MESSAGE_DIALOG as common ancestor
Laabhair documentation additions
Linux install/uninstall apps
Made EL_WORD_SEARCHABLE more efficient when regenerating word_token_list
Made string constant classes inherit from EL_ANY_SHARED
More efficient list iteration in TagLib
Moved search engine cluster to library/text
Moved text editing, parsing and pattern-matching classes from base.ecf to text-process.ecf
New class CROSS_PLATFORM_EIFFEL_CONFIGURATION_FILE
New class el_counter_table and {EL_LOGGABLE}.put_natural_field
New class EL_ITERABLE_CONVERTER and EL_FILE_MANIFEST_COMMAND
New class EL_MODEL_ROTATED_PICTURE and EL_MODEL_BUFFER_PROJECTOR
New class EL_MODEL_ROTATED_SQUARE_PICTURE
New class EL_MODULE_CHECKSUM and added new routines to EL_CYCLIC_REDUNDANCY_CHECK_32
New class el_module_ip_address and el_module_geographic
New class EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML
New class EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
New class EL_SHARED_SINGLETON
New class EVOLICITY_REFLECTIVE_EIFFEL_CONTEXT
New routine {EL_MANAGED_CONTAINABLE}.make_with_container_at_position
New routine {EL_SUB_APPLICATION}.new_locale
Obtain cluster description from ecf in repository publisher
Optimizations to EL_DIR_PATH joining from lists
Optimized {EL_DIGEST_ARRAY}.to_uuid
override for index_of in EL_CHAIN
Perfected EL_WORK_DISTRIBUTER for short and long tasks
Polished EL_INPUT_WIDGET and descendants
Polished EL_STRING_EDITION_HISTORY and created test unit
Postcondition for {EVOLICITY_EIFFEL_CONTEXT}.new_getter_functions
Put el_file_manifest_list back in xdoc-scanning project
Python c_library: pkg.download (); pkg.unpack (); pkg.remove ()
Read artist, album, title from taglib ID3 tags
Refactored duplicity backup and restore utility
Refactored EL_CLASS_META_DATA
Refactored EL_WORD_SEARCHABLE for better efficiency and robustness
Refactored Paypal API to make it 100% reflective
Refactored progress tracking to use EL_MODULE_TRACK
Refactored search engine to use EL_QUERY_CONDITION
Refactoring for change to EL_CHAIN.append
Refactoring of all EL_MODULE descendants
Refactoring of ID3-tags library
Refinements to TEST_WORK_DISTRIBUTER_APP
Refining operation of class el_storable_class_meta_data.e
Reimplemented EL_WORK_DISTRIBUTER to use a sempahore
Removed EL_ADAPTER_CONSTANTS from network.ecf
Removed EL_ROUTINE_APPLICATOR and added EL_BENCHMARK_COMPARISON
Removed {EL_WORK_DISTRIBUTER}.new_routine_list
Removed *.evc files
Removed example/manage-mp3/build directory
Renamed EL_FILE_CRC_32_SYNC_ITEM as EL_FILE_SYNC_ITEM
Renamed INTEGER_MATH
Renaming of chain-db to Eco-DB
Replaced EL_APPLICATION_CONFIG_CELL with EL_APP_CONFIGURATION
Replaced EL_FILE_LINE_SOURCE with EL_PLAIN_TEXT_LINE_SOURCE
Replaced HASH_TABLE search with has_key
Restructured test.ecf into 3 clusters
Restructured Vision-2-x into 4 clusters
Restructure Vision2-x extensions cluster
Revised exception handling for broken pipe in FCGI_SERVLET_SERVICE
Rotatable Russian doll graphics model
Scons build can now increment build in both pecf and ecf
Separated help and argument functions from EL_SUB_APPLICATION into EL_APPLICATION_ARGUMENTS
set item on EL_PATH_STEPS to return twin
Simplified class EL_DIGEST_ARRAY to use fewer creation procedures
Simplified EL_CLASS_META_DATA.reference_type_id to iterate over a list of base types
Simplified EL_MULTI_APPLICATION_ROOT and related classes
Simplified EL_PROGRESS_TRACKER
Split EL_SHARED_ONCE_STRINGS into 3 classes
Split EXPERIMENTS_APP into categories by class
Successfull first test of EL_DEBIAN_PACKAGER
Successfully tested el_debian_make_script
Support for reflective dot operator
Testing tag->title () value copy
Test Python builder to copy externally built C library
Thunderbird export now configured by Pyxis file
Undefined routines from CHAIN in ECD_CHAIN
Updated applications with changes to AUTOTEST_DEVELOPMENT_APP
Updated class notes
Updated ecf descriptions on repository publisher
Updated EL_MODULE_BUILD_INFO to use new singleton pattern based on EL_SINGLETON_TABLE
Update descriptions for EL_CHAIN_STRING_LIST_COMPILER
Updated reflection system to use new instance functions in class EL_SHARED_NEW_INSTANCE_TABLE
Updated repository publisher to use EL_STRING_EDITOR
Update to AIA notes
Update to eco-db.txt
Using TUPLE's to specifiy list of factory types
Various
Version 1.0.18 of Eiffel-View repository publisher
Vision 2 extensions mods
