# Eiffel-Loop Contents
## Submission for 99-bottles-of-beer.net
Eiffel submission for [http://www.99-bottles-of-beer.net/ www.99-bottles-of-beer.net].

This website contains sample programs for over 1500 languages and variations, all of which print the lyrics of the song "99 Bottles of Beer".
## Concurrency Demonstration
Demonstration of classes that make the classic multi-threading ISE library `thread.ecf' easier to use.


1. `el_concurrency -horse_race' An [https://www.youtube.com/watch?v=s2-7pzmVjao animated version] of the classic concurrency horse-racing exercise.
2. `el_concurrency -work_distributer' demonstrates the calculation of integrals for arbitrary functions distributed across a specified number of threads
## Vision-2 Extensions Demo
Test application for selected components from Eiffel-Loop [./library/vision2-x.html extension libraries for Vision-2 and Docking].
## Rhythmbox MP3 Collection Manager
This is a full-blown MP3 collection manager that is designed to work in conjunction with the [Rhythmbox media player](https://wiki.gnome.org/Apps/Rhythmbox) and has a number of features of particular interest to Tango DJs.

**Manger Syntax**


````
el_rhythmbox -manager -config <task-configuration>.pyx
````
**Features**


* Integrates with the GNOME desktop and the [GNOME terminal](https://en.wikipedia.org/wiki/GNOME_Terminal) so you can drag and drop task configuration files on to either a [desktop launcher](https://developer.gnome.org/integration-guide/stable/desktop-files.html.en) or the GNOME terminal.
* Automatically add album art to MP3 files from a directory based on album name or artist name.
* Collate songs into a directory structure according to song tags:


````
<genre>/<artist-name>/<song-title>.<unique id>.mp3
````
* Import videos in various formats as MP3 files automatically adding ID3 tags according to folder location. Includes facility for mapping video segments to individual MP3 files.
* Replace songs marked as duplicated, updating all playlists and removing replaced song from collection.
* Display all ID3 tag comments
* Create [tango cortinas](https://en.wikipedia.org/wiki/Cortina_(tango)) to act as breaks between a set of dance songs.
* Delete all ID3 tag comments except for the Rhythmbox 'c0' comment. (Gets rid of iTune identifiers etc.)
* Remove all UFID fields from ID3 tags
* Store playlists in a special format that can be easily edited in a text editor to add DJ event information.
* Publish playlists augmented with DJ event information to a website using an Evolicity HTML template.
* Display [MusicBrainz info](https://en.wikipedia.org/wiki/MusicBrainz) for any songs that have it.
* Display songs with incomplete [TXXX ID3](http://id3.org/id3v2.3.0#Declared_ID3v2_frames) tags (User defined text).
* Archive songs placed in a special "Archive" playlist. This removes them from the main Rhythmbox collection but does not delete them.
* Append field "album-artist" into main 'c0' comment.
* Replace 'c0' comment with album-artist info
* Synchronize all (or selected genres) of music with connected device.
* Export all playlists and associated MP3 to external device
* Has a trick where the beats-per-minute ID3 field can be used to generate a silent pause after particular songs in a playlist.
* Writes a unique audio signature into the MusicBrainz track id to facilitate foolproof device synchronization.

**Manual**

For details on how to use, read the source documentation notes in class [http://www.eiffel-loop.com/example/manage-mp3/source/apps/rhythmbox_music_manager_app.html](RHYTHMBOX_MUSIC_MANAGER_APP).

**Download**

Download the latest executable for *Ubuntu 14.04* or *Linux Mint 17.x* at the bottom of [this page](https://github.com/finnianr/Eiffel-Loop/releases/latest). You also need the following command line tools to be installed: `sox, swgen, avconv, lame, gvfs-mount`.

Warning: **Use at your own risk.** It is recommended that you have a backup of your MP3 collection and rhythmbox configuration files (Usually in `$HOME/.local/share/rhythmbox`). The developer does not take any responsibility for any data loss that may occur as a result of using *el_rhythmbox*.
## Signal Math Demo of the EROS Protocol
A multi-mode application demonstrating the [EROS remote object protocol](http://www.eiffel-loop.com/library/eros.html). The application calculates Fourier transformations based on Greg Lee's [Numeric Eiffel Library](https://teameiffel.blogspot.com/2006/04/greg-lees-numeric-eiffel-library.html). It has two client modes and two server modes, accessible via a command line option.

**Client Modes**

`-test_client` Sub-application [http://www.eiffel-loop.com/example/net/EROS/signal-math/source/apps/fft_math_client_test_app.html](FFT_MATH_CLIENT_TEST_APP)

Test client to generate random wave forms and do fourier transforms for 25 seconds

`-bext_test_client` Sub-application [http://www.eiffel-loop.com/test/source/eros/apps/bext_client_test_app.html](BEXT_CLIENT_TEST_APP)

Client to test Binary Encoded XML Transfer (BEXT).

**Server Modes**

`-bext_test_server` Sub-application [http://www.eiffel-loop.com/test/source/eros/apps/bext_client_test_app.html](BEXT_CLIENT_TEST_APP)

Server to test Binary Encoded XML Transfer (BEXT). Ctrl-c shuts down the server.

`-test_server` Sub-application [http://www.eiffel-loop.com/example/net/EROS/signal-math/source/apps/fft_math_server_test_app.html](FFT_MATH_SERVER_TEST_APP)

Single connection test server for fourier math. Ctrl-c shuts down the server.

**Installer Mode**

`-install` Sub-application [http://www.eiffel-loop.com/library/runtime/app-manage/standard-app/el_standard_installer_app.html](EL_STANDARD_INSTALLER_APP)

Installs application with desktop menu options for each mode.
## Signal Math EROS Server with GUI
A multi-threaded EROS server demonstrating the [EROS remote object protocol](http://www.eiffel-loop.com/library/eros.html). The application performs signal math including Fourier transformations based on Greg Lee's [Numeric Eiffel Library](https://teameiffel.blogspot.com/2006/04/greg-lees-numeric-eiffel-library.html)

**Features**


* A graphical user interface (GUI) to control startup and shutdown.
* GUI monitors 11 different performance characteristics.
* GUI has controls allowing you to switch the console logging output to a different thread context.

**Screenshot**

[Server GUI and terminal window displaying logging output](http://www.eiffel-loop.com/images/screenshot/console-thread-switch.png)
## Protein Folding using 2D HP model
Various implementations of an optimal protein folding algorithm using the 2D HP model Includes both a single and multi-core implementation.

This project was a joint collaboration between Gerrit Leder and Finnian Reilly. Gerrit developed the implemented the 2D HP algorithm in Eiffel and Finnian optimized it's performance and created a multi-core parallel computation version.

The multi-core version showcases the Eiffel-Loop class [http://www.eiffel-loop.com/library/runtime/concurrency/communication/producer-consumer/distributer/el_procedure_distributer.html](EL_PROCEDURE_DISTRIBUTER).

See: [Sourceforge repository PF_HP-mt](https://sourceforge.net/p/pfhp/PF_HP-mt)
## Audio Processing
Classes for processing audio files and sample data.
## Video Processing
Wrappers for various video conversion operations using OS commands
## ID3 Tagging for MP3
**Description**

Classes for reading and writing ID3 tags to MP3 files using a common interface to the C libraries `libid3tag (C)` and `id3lib (C++)`. The former C library is used for ID3 version 2.4 tags and the latter for earlier versions from 2.0 to 2.3.

**Status Obsolete**

Due to numerous problems with the id3lib C++ library this project has been abandoned in favor of the [TagLib library](http://www.eiffel-loop.com/library/TagLib.html) which is still maintained and supports many more meta-data types besides ID3.
## TagLib Audio Meta-Data Library
Eiffel binding for the ID3 v1 and v2 tag manager from the [TagLib C++ library](https://taglib.org/).

TagLib can read and edit the meta-data of many popular audio formats. Currently it supports both ID3v1 and ID3v2 for MP3 files, Ogg Vorbis comments and ID3 tags and Vorbis comments in FLAC, MPC, Speex, WavPack, TrueAudio, WAV, AIFF, MP4 and ASF files.

**Test Set**

[test/test.ecf#taglib](http://www.eiffel-loop.com/test/test.taglib.html)

**Future Development**

Support for `m4a` and `flac` meta-data.

**Credits**

Special thanks to [Scott Wheeler](https://github.com/scotchi), the original author of the TagLib library, for his kind assistance and and support in creating this Eiffel binding.
## Windows Audio
Audio extensions for the [WEL GUI library](https://www.eiffel.org/doc/solutions/WEL) that facilitate playback and other audio functions.
## Vision2 Audio
Audio extensions for Windows implementation of Vision2 GUI library. This depends on the [WEL audio extensions](http://www.eiffel-loop.com/library/wel-x-audio.html) library.
## Laabhair Audio Analysis Framework
**Status:** No longer maintained

The *Laabhair** audio analysis framework was developed at the [Digital Media Centre at the Dublin Institute of Technology](https://arrow.dit.ie/dmc/) to do audio analysis with Eiffel in real-time, presenting graphical audio representations using an [Adobe Flash player](https://www.adobe.com/products/flashplayer.html) GUI.

(**Laabhair is the Gaelic for talk.*)

**Benefits for various developer audiences**

*Eiffel Programmers*


1. Easy access to the advanced sound analysis capabilities of Praat and conversely gives Praat programmers easy access to the advanced engineering capabilities of Eiffel. Praat script is an elegant little language with an ADA like syntax that does for sound analysis what PL/SQL does for database querying. The level of Eiffel required to make use of the framework is very minimal. The essence of a Laabhair application can be understood from a single Eiffel class.
2. Easy access to the advanced presentation capabilities of Flash and conversely gives Flash programmers easy access to the advanced engineering capabilities of Eiffel. The most significant part of this framework is an elegantly simple XML-orientated network-RPC protocol allowing Eiffel to make asynchronous calls to ActionScript procedures in a Flash application. Unlike SOAP, Laabhair RPC messages have a very transparent syntax that is self-explanatory. Communication in the other direction is through parameterless commands representing Flash button clicks.

*Praat programmers*

Easy access to the advanced presentation capabilities of Flash and conversely gives Flash programmers easy access to the advanced sound analysis capabilities of Praat.

**Structure of the Laabhair framework**

The framework is used to develop both an Eiffel sound analyis program and a Flash presentation program which communicate over a network socket. The analyzer has a small GUI consisting of a status light and a sound level meter and a minimize and close caption bar button. The analyzer window situates itself in the top right hand corner. The presentation application is launched in fullscreen mode by the analyzer. The analyzer window is set to be "always on top" so it is not obscured by the Flash application. A button on the Flash GUI is used to stop and start the analyzer taking input from the mic. Another button closes the application.

The sound analysis program implements an application specific Praat analyzer which is fed by a continuous stream of small sound clips streamed from audio input. (Typically of 100 millisecs duration) The analyzer class contains an embedded Praat script which is run for each sound clip sample. The analyzer does some calculation on the results (in Eiffel) before calling (asynchronously) a Flash presentation procedure with the results.

The framework allows editing of application configuration values in a dialog activated from a drop down menu. Each time the analyzer is activated any edit changes are propagated to registered listeners. Out of the box the configuration edit dialog allows you to change the following parameters:


* Location of an external Praat script to be used in place of the embedded script (useful for testing)
* Change the duration of each audio sample clip fed to the analyzer. (default is 100 ms)
* Change the signal threshold below which audio input is ignored. (Set to a higher value when operating in a noisey environment)

All of the configurable values can also be set from the command line at startup.

**Related libraries in Eiffel-Loop**


* Eiffel interface to the Windows sound input API  allowing streaming audio from the microphone to be processed in Eiffel using classes from the producer-consumer thread library. The wrapper is implemented as a WEL extension.
* Eiffel interface to the Praat sound analysis engine and script interpreter. The wrapper allows Praat scripts to be run from Eiffel and the resulting values of script variables to be accessed from Eiffel. The wrapper uses a modified version of the Praat source code allowing operation from Eiffel and compilation as a library using the MSVC command line compiler.

## String Buffering
Classes for buffering string data in shared objects
## Data Structure
Various hash-table, array, list, chain and linear types

**Hash Tables**


````
HASH_TABLE [G, K -> HASHABLE]
	${SED_OBJECTS_TABLE}
	${CLASS_NAME_TRANSLATIONS}
	${MISMATCH_INFORMATION}
	${HASH_TABLE_EX} [G, K -> ${HASHABLE}]
	${EQUALITY_HASH_TABLE} [G -> ${ANY}, H -> ${HASHABLE}]
	${STRING_TABLE} [G]
	${EL_HASH_TABLE} [G, K -> ${HASHABLE}]
		${EL_TYPE_TABLE} [G]
		${EL_STRING_32_TABLE} [G]
		${EL_STRING_GENERAL_TABLE} [G]
		${EL_CONFORMING_INSTANCE_TABLE} [G]
		${EL_STRING_8_TABLE} [G]
			${EVOLICITY_FUNCTION_TABLE}
			${EL_XPATH_TOKEN_TABLE}
			${EL_FIELD_VALUE_TABLE} [G]
			${EL_DATE_FUNCTION_TABLE}
		${EL_STRING_HASH_TABLE} [G, K -> ${STRING_GENERAL} create make end]
			${EL_PROCEDURE_TABLE} [K -> ${STRING_GENERAL} create make end]
			${EL_ZSTRING_HASH_TABLE} [G]
				${EL_TRANSLATION_TABLE}
				${TB_ATTRIBUTE_EDIT_TABLE}
		${EL_STRING_CONVERSION_TABLE}
		${EL_IMMUTABLE_KEY_8_TABLE} [G]
			${EL_FIELD_TABLE}
			${EL_OBJECT_FIELDS_TABLE}
	${EL_LOG_FILTER_SET} [TYPE_LIST -> ${TUPLE} create default_create end]
	${EL_COUNTER_TABLE} [K -> ${HASHABLE}]
	${EL_OBJECTS_BY_TYPE}
	${EL_EIF_OBJ_TEXT_TABLE_CONTEXT}
	${EL_STRING_ESCAPER} [S -> ${STRING_GENERAL} create make end]
		${XML_ESCAPER} [S -> ${STRING_GENERAL} create make end]
		${EL_CSV_ESCAPER} [S -> ${STRING_GENERAL} create make end]
	${EL_FUNCTION_RESULT_TABLE} [TARGET, R]
	${EL_STRING_GENERAL_UNESCAPER}* [R -> ${READABLE_STRING_GENERAL}, G -> ${STRING_GENERAL}]
		${EL_STRING_8_UNESCAPER}
		${EL_STRING_32_UNESCAPER}
		${EL_ZSTRING_UNESCAPER}
			${JSON_UNESCAPER}
	${EL_URI_QUERY_HASH_TABLE}* [S -> ${STRING_GENERAL} create make end]
		${EL_URI_QUERY_STRING_8_HASH_TABLE}
		${EL_URI_QUERY_STRING_32_HASH_TABLE}
		${EL_URI_QUERY_ZSTRING_HASH_TABLE}
	${EL_GROUP_TABLE} [G, K -> ${HASHABLE}]
		${EL_FUNCTION_GROUP_TABLE} [G, K -> ${HASHABLE}]
	${EL_CODE_TABLE} [K -> ${HASHABLE}]
		${EL_UNIQUE_CODE_TABLE} [K -> ${HASHABLE}]
			${EL_ZSTRING_TOKEN_TABLE}
				${EL_WORD_TOKEN_TABLE}
	${EL_ESCAPE_TABLE}
	${EL_LOCALE_TABLE}
	${XML_NAME_SPACE_TABLE}
	${EL_HTTP_COOKIE_TABLE}
	${EL_CACHE_TABLE}* [G, K -> ${HASHABLE}]
		${EL_NAME_TRANSLATER_TABLE}
		${EL_INITIALIZED_OBJECT_FACTORY} [F -> ${EL_FACTORY} [G], G]
			${EL_INITIALIZED_FIELD_FACTORY}
		${EL_AGENT_CACHE_TABLE} [G, K -> ${HASHABLE}]
		${EL_LOCALE_TEXTS_TABLE} [TEXTS -> ${EL_REFLECTIVE_LOCALE_TEXTS} create make, make_with_locale end]
		${EL_IP_ADDRESS_GEOLOCATION_TABLE}
		${EL_FACTORY_TYPE_ID_TABLE}
	${EVOLICITY_TEMPLATE_STACK_TABLE}
	${EL_SINGLETON_TABLE}
	${EL_FUNCTIONS_BY_RESULT_TYPE}
	${EL_CURL_HEADER_TABLE}
	${EL_PASSPHRASE_EVALUATOR}
	${EL_ZSTRING_TABLE}
	${EL_COMPRESSION_TABLE} [G -> ${EL_STORABLE} create make_default end, K -> ${HASHABLE}]
		${EL_GEOGRAPHIC_INFO_TABLE}
	${EL_IMMUTABLE_STRING_TABLE}* [GENERAL -> ${STRING_GENERAL} create make end, IMMUTABLE -> ${IMMUTABLE_STRING_GENERAL}]
		${EL_IMMUTABLE_STRING_32_TABLE}
		${EL_IMMUTABLE_STRING_8_TABLE}
			${EL_IMMUTABLE_UTF_8_TABLE}
			${EL_TUPLE_FIELD_TABLE}
	${ECD_INDEX_TABLE}* [G -> ${EL_STORABLE} create make_default end, K -> ${HASHABLE}]
		${ECD_REFLECTIVE_INDEX_TABLE} [G -> ${EL_REFLECTIVELY_SETTABLE_STORABLE} create make_default end, K -> ${HASHABLE}]
	${EL_FUNCTION_CACHE_TABLE} [G, OPEN_ARGS -> ${TUPLE} create default_create end]
		${EL_FILLED_STRING_8_TABLE}
		${EL_LOCALIZED_CURRENCY_TABLE}
		${EL_FILLED_STRING_TABLE}* [STR -> ${READABLE_STRING_GENERAL}]
			${EL_FILLED_STRING_32_TABLE}
			${EL_FILLED_ZSTRING_TABLE}
	${EL_XPATH_ACTION_TABLE}
````
**Linear Chains**


````
EL_LINEAR* [G]
	${EL_CHAIN}* [G]
		${EL_ARRAYED_LIST} [G]
			${EL_TUPLE_TYPE_LIST} [T]
			${EL_CALL_SEQUENCE} [CALL_ARGS -> ${TUPLE} create default_create end]
			${EL_UNIQUE_ARRAYED_LIST} [G -> ${HASHABLE}]
			${EL_DIRECTORY_LIST}
			${EL_APPLICATION_LIST}
			${EL_SORTABLE_ARRAYED_LIST} [G -> ${COMPARABLE}]
				${EL_FILE_PATH_LIST}
				${EL_DIRECTORY_PATH_LIST}
					${EL_NATIVE_DIRECTORY_PATH_LIST}
				${EL_FILE_MANIFEST_LIST}
				${EL_STRING_LIST} [S -> ${STRING_GENERAL} create make end]
					${EL_STRING_8_LIST}
						${EVOLICITY_VARIABLE_REFERENCE}
							${EVOLICITY_FUNCTION_REFERENCE}
						${AIA_CANONICAL_REQUEST}
					${EL_ZSTRING_LIST}
						${EL_XHTML_STRING_LIST}
						${XML_TAG_LIST}
							${XML_PARENT_TAG_LIST}
							${XML_VALUE_TAG_PAIR}
						${EL_ERROR_DESCRIPTION}
							${EL_COMMAND_ARGUMENT_ERROR}
						${TB_HTML_LINES}
					${EL_STRING_32_LIST}
					${EL_TEMPLATE} [S -> ${STRING_GENERAL} create make, make_empty end]
						${EL_DATE_TEXT_TEMPLATE}
				${EL_IMMUTABLE_STRING_8_LIST}
					${EL_IMMUTABLE_UTF_8_LIST}
			${EL_DEFAULT_COMMAND_OPTION_LIST}
			${EL_NETWORK_DEVICE_LIST_I}*
				${EL_NETWORK_DEVICE_LIST_IMP}
			${TP_ALL_IN_LIST}
				${TP_FIRST_MATCH_IN_LIST}
			${JOBS_RESULT_SET}
			${EL_HTTP_PARAMETER_LIST}
			${EL_OPF_MANIFEST_LIST}
			${EL_ARRAYED_COMPACT_INTERVAL_LIST}
			${EL_DISCARDING_ARRAYED_LIST} [G]
			${EL_NAMEABLES_LIST} [G -> ${EL_NAMEABLE} [READABLE_STRING_GENERAL]]
			${EL_ARRAYED_MAP_LIST} [K, G]
				${EL_APPLICATION_HELP_LIST}
				${EL_DECOMPRESSED_DATA_LIST}
				${EL_STRING_POOL} [S -> ${STRING_GENERAL} create make end]
				${EL_BOOK_ASSEMBLY}
				${EL_CONFORMING_INSTANCE_TYPE_MAP} [G]
				${EL_HASHABLE_KEY_ARRAYED_MAP_LIST} [K -> ${HASHABLE}, G]
				${EL_KEY_INDEXED_ARRAYED_MAP_LIST} [K -> ${COMPARABLE}, G]
				${EL_STYLED_TEXT_LIST}* [S -> ${STRING_GENERAL}]
					${EL_STYLED_STRING_8_LIST}
					${EL_STYLED_STRING_32_LIST}
					${EL_STYLED_ZSTRING_LIST}
			${EL_ARRAYED_RESULT_LIST} [G, R]
			${EL_SPLIT_READABLE_STRING_LIST} [S -> ${READABLE_STRING_GENERAL} create make end]
				${EL_SPLIT_STRING_LIST} [S -> ${STRING_GENERAL} create make end]
					${EL_SPLIT_ZSTRING_LIST}
					${EL_SPLIT_STRING_32_LIST}
					${EL_SPLIT_STRING_8_LIST}
				${EL_SPLIT_IMMUTABLE_STRING_LIST}* [GENERAL -> ${STRING_GENERAL}, IMMUTABLE -> ${IMMUTABLE_STRING_GENERAL} create make end]
					${EL_SPLIT_IMMUTABLE_STRING_8_LIST}
						${EL_SPLIT_IMMUTABLE_UTF_8_LIST}
					${EL_SPLIT_IMMUTABLE_STRING_32_LIST}
				${EL_COMPACT_ZSTRING_LIST}
				${EL_IMMUTABLE_STRING_GRID}* [GENERAL -> ${STRING_GENERAL}, IMMUTABLE -> ${IMMUTABLE_STRING_GENERAL} create make end]
					${EL_IMMUTABLE_STRING_8_GRID}
					${EL_IMMUTABLE_STRING_32_GRID}
			${EL_TRANSLATION_ITEMS_LIST}
			${TB_EMAIL_LIST}
			${EL_COMMA_SEPARATED_WORDS_LIST}
			${CSV_IMPORTABLE_ARRAYED_LIST} [G -> ${EL_REFLECTIVELY_SETTABLE} create make_default end]
			${EL_ARRAYED_INTERVAL_LIST}
				${TP_REPEATED_PATTERN}*
					${TP_COUNT_WITHIN_BOUNDS}
						${TP_ONE_OR_MORE_TIMES}
						${TP_ZERO_OR_MORE_TIMES}
					${TP_LOOP}*
						${TP_P1_UNTIL_P2_MATCH}
						${TP_P2_WHILE_NOT_P1_MATCH}
				${EL_SEQUENTIAL_INTERVALS}
					${EL_OCCURRENCE_INTERVALS}
						${JSON_PARSED_INTERVALS}
							${JSON_NAME_VALUE_LIST}
								${JSON_ZNAME_VALUE_LIST}
						${EL_SPLIT_INTERVALS}
							${EL_ZSTRING_SPLIT_INTERVALS}
							${EL_STRING_8_SPLIT_INTERVALS}
							${EL_STRING_32_SPLIT_INTERVALS}
						${EL_ZSTRING_OCCURRENCE_INTERVALS}
							${EL_ZSTRING_SPLIT_INTERVALS}
							${EL_ZSTRING_OCCURRENCE_EDITOR}
						${EL_STRING_8_OCCURRENCE_INTERVALS}
							${EL_STRING_8_SPLIT_INTERVALS}
							${EL_STRING_8_OCCURRENCE_EDITOR}
						${EL_STRING_32_OCCURRENCE_INTERVALS}
							${EL_STRING_32_SPLIT_INTERVALS}
							${EL_STRING_32_OCCURRENCE_EDITOR}
					${JSON_INTERVALS_OBJECT} [FIELD_ENUM -> ${EL_ENUMERATION_NATURAL_16} create make end]
						${EL_IP_ADDRESS_META_DATA}
					${EL_ZSTRING_INTERVALS}
						${EL_COMPARABLE_ZSTRING_INTERVALS}* [C, S -> ${READABLE_INDEXABLE} [C]]
							${EL_COMPARE_ZSTRING_TO_STRING_32}
								${EL_CASELESS_COMPARE_ZSTRING_TO_STRING_32}
							${EL_COMPARE_ZSTRING_TO_STRING_8}
								${EL_CASELESS_COMPARE_ZSTRING_TO_STRING_8}
			${EL_FIELD_LIST}
			${EL_ARRAYED_REPRESENTATION_LIST}* [R, N]
				${DATE_LIST}
			${EL_REFLECTED_REFERENCE_LIST}
			${EL_QUERYABLE_ARRAYED_LIST} [G]
				${ECD_ARRAYED_LIST} [G -> ${EL_STORABLE} create make_default end]
					${COUNTRY_DATA_TABLE}
					${ECD_STORABLE_ARRAYED_LIST} [G -> ${EL_STORABLE} create make_default end]
				${AIA_CREDENTIAL_LIST}
					${AIA_STORABLE_CREDENTIAL_LIST}
			${EL_PATH_STEP_TABLE}
			${EL_EVENT_LISTENER_LIST}
				${EL_EVENT_BROADCASTER}
			${EL_XDG_DESKTOP_ENTRY_STEPS}
		${EL_STRING_CHAIN}* [S -> ${STRING_GENERAL} create make end]
			${EL_LINKED_STRING_LIST} [S -> ${STRING_GENERAL} create make, make_empty end]
			${EL_STRING_LIST} [S -> ${STRING_GENERAL} create make end]
		${EL_QUERYABLE_CHAIN}* [G]
			${EL_QUERYABLE_ARRAYED_LIST} [G]
	${EL_FILE_GENERAL_LINE_SOURCE}* [S -> ${STRING_GENERAL} create make end]
		${EL_STRING_8_IO_MEDIUM_LINE_SOURCE}
		${EL_PLAIN_TEXT_LINE_SOURCE}
			${EL_ENCRYPTED_PLAIN_TEXT_LINE_SOURCE}
		${EL_ZSTRING_IO_MEDIUM_LINE_SOURCE}
	${EL_LINEAR_STRINGS}* [S -> ${STRING_GENERAL} create make end]
		${EL_SPLIT_STRING_LIST} [S -> ${STRING_GENERAL} create make end]
		${EL_STRING_CHAIN}* [S -> ${STRING_GENERAL} create make end]
````
**Other Classes**


* Sub-array abstraction and byte array
* Repeated numeric encoding
* Tuple initialization
* Object initialization abstractions
* Software versioning


## Date and Time
Classes for parsing and formatting date and time strings.
## Files and Directories
Classes for the following:


* Naming files and directories
* Reading file properties
* Processing directory data
* Processing file data
* File transfer synchronization

## Class Creation and Initialization
Classes for the following:


* Creating and initializing instances of a class.
* Factory indirection, i.e. factories for creating factories.
* Managing cross-platform bridge initialization
* Managing `Precursor` calls to avoid repeats
* Managing creation and initialization of singleton objects
* Managing creation of "lazy attributes"

## Input/Output
Classes for the following:


* Writing to the console with color highlighting
* Read user input data

## Kernel
Fundamental base classes
## Math
Some basic math classes for the following:


* 2D geometry
* Calculating integrals of arbitrary functions
* Representing column vectors

## Data Persistence
Classes providing the following facilities:


* Reading and writing arrays of floating-point type [https://www.eiffel.org/files/doc/static/trunk/libraries/base/real_64_chart.html](REAL_64).
* Files that notify a listener of byte-count written and read.
* A file conforming to [https://www.eiffel.org/files/doc/static/trunk/libraries/base/plain_text_file_chart.html](PLAIN_TEXT_FILE) that implements [http://www.eiffel-loop.com/library/base/runtime/io/medium/el_output_medium.html](EL_OUTPUT_MEDIUM)
* File line source and other abstractions

## Class Reflection
Building on the basic ISE reflection mechanisms, this cluster makes possible a very flexible way of exchanging data between Eiffel objects and any structured plaintext format, and also a binary memory block conforming to [http://www.eiffel-loop.com/library/base/runtime/memory/reader-writer/el_memory_reader_writer.html](EL_MEMORY_READER_WRITER) (inherits [https://www.eiffel.org/files/doc/static/trunk/libraries/base/sed_memory_reader_writer_chart.html](SED_MEMORY_READER_WRITER))

**Key Features**


* Support for mapping between various name-style conventions: eg. kebab-case, camel-case, snake-case, upper-snake-case etc.
* Support of automatic initialization of reference types with means of adding adhoc types. (non-void safe compiler)
* Support for numeric enumerations with reflective assignment from strings and optional mappings to extended descriptions. For example: [Unknown-path](EL_PASSPHRASE_ATTRIBUTES_ENUM).
* Basis for reflective initialization of class attributes from command line arguments. See class [http://www.eiffel-loop.com/library/base/kernel/command/options/el_command_line_options.html](EL_COMMAND_LINE_OPTIONS)
* Support for reading and writing to strings conforming to [https://www.eiffel.org/files/doc/static/trunk/libraries/base/string_general_chart.html](STRING_GENERAL)
* Support for reading from objects conforming to [http://www.eiffel-loop.com/library/base/kernel/el_readable.html](EL_READABLE) and writing to objects conforming to [Unknown-path](EL_WRITEABLE)
* Support for reading writing to instance of [http://www.eiffel-loop.com/library/base/runtime/memory/reader-writer/el_memory_reader_writer.html](EL_MEMORY_READER_WRITER) (inherits [https://www.eiffel.org/files/doc/static/trunk/libraries/base/sed_memory_reader_writer_chart.html](SED_MEMORY_READER_WRITER))
* Support for recursively pretty-printing object data to console (with color highlighting in Linux)
* Support for sinking field data into object conforming to [http://www.eiffel-loop.com/library/base/runtime/memory/el_data_sinkable.html](EL_DATA_SINKABLE). Useful for creating MD5 or SHA-256 hashes.
* Flexible way to include and exclude fields stored in field table.
* Support for extracting useful type information from agents in an easily accessible form.
* Support over 50 standard field types and composite types with ad-hoc support for other classes to serialize to [http://www.eiffel-loop.com/library/base/runtime/memory/reader-writer/el_memory_reader_writer.html](EL_MEMORY_READER_WRITER).


````
EL_REFLECTED_FIELD*
	${EL_REFLECTED_REFERENCE} [G]
		${EL_REFLECTED_REFERENCE_ANY}
		${EL_REFLECTED_TEMPORAL}* [G -> ${ABSOLUTE}]
			${EL_REFLECTED_TIME}
			${EL_REFLECTED_DATE_TIME}
			${EL_REFLECTED_DATE}
		${EL_REFLECTED_COLLECTION} [G]
		${EL_REFLECTED_TUPLE}
		${EL_REFLECTED_BOOLEAN_REF}
		${EL_REFLECTED_MANAGED_POINTER}
		${EL_REFLECTED_STORABLE}
		${EL_REFLECTED_HASHABLE_REFERENCE} [H -> ${HASHABLE}]
			${EL_REFLECTED_STRING}* [S -> ${READABLE_STRING_GENERAL} create make end]
				${EL_REFLECTED_URI} [U -> ${EL_URI} create make end]
				${EL_REFLECTED_STRING_8}
				${EL_REFLECTED_IMMUTABLE_STRING_8}
				${EL_REFLECTED_IMMUTABLE_STRING_32}
				${EL_REFLECTED_ZSTRING}
				${EL_REFLECTED_STRING_32}
			${EL_REFLECTED_PATH}
		${EL_REFLECTED_MAKEABLE_FROM_STRING}* [MAKEABLE -> ${EL_MAKEABLE_FROM_STRING} [STRING_GENERAL]]
			${EL_REFLECTED_MAKEABLE_FROM_STRING_8}
			${EL_REFLECTED_MAKEABLE_FROM_STRING_32}
			${EL_REFLECTED_MAKEABLE_FROM_ZSTRING}
	${EL_REFLECTED_EXPANDED_FIELD}* [G]
		${EL_REFLECTED_NUMERIC_FIELD}* [N -> ${NUMERIC}]
			${EL_REFLECTED_INTEGER_FIELD}* [N -> ${NUMERIC}]
				${EL_REFLECTED_NATURAL_16}
				${EL_REFLECTED_NATURAL_8}
				${EL_REFLECTED_NATURAL_32}
				${EL_REFLECTED_INTEGER_8}
				${EL_REFLECTED_INTEGER_16}
				${EL_REFLECTED_INTEGER_32}
				${EL_REFLECTED_INTEGER_64}
				${EL_REFLECTED_NATURAL_64}
			${EL_REFLECTED_REAL_32}
			${EL_REFLECTED_REAL_64}
		${EL_REFLECTED_BOOLEAN}
		${EL_REFLECTED_POINTER}
		${EL_REFLECTED_CHARACTER_8}
		${EL_REFLECTED_CHARACTER_32}
## Runtime Operations
Classes for the following:


* Exception handling
* Reading and writing from memory locations
* Accessing operating environment information
* Tracking progress of time consuming operations
* Managing shared resources for competing threads
## Text Processing
Classes providing the following:


* Character and character sequence conversion
* Character encoding
* Class and routine naming-convention translation
* Converting string data to other basic types
* Deferred internationalization
* Text line processing
* Parsing and manipulating name-value pairs
* Classes for reading and mapping command line arguments
* Associating formatting styles with strings
* URI encoding/decoding
* UTF encoding/decoding
## String Handling
Classes providing the following:


* Abstractions for objects createable from strings
* Escaping and unescaping
* Iterating substring splits based on a character or substring separator
* Jail-breaking immutable strings
* Recording and managing string edit histories
* Specialized types of strings
* String template substitution
* Supplementary string routines for general use
## Substring Structures
Container classes for substrings


* Compacted arrays of substrings
* Grids of substrings
* Lists of substrings
* String occurrence interval lists
* Tables of substrings
## Software Versioning and CRC digest
Classes providing the following facilities:


* Software version formatting and storing application build information
* Cyclic redundancy checksum generation
## Class ZSTRING
An implementation of a memory compact string with the same unicode character range as the ''base.ecf'' class ${STRING_32} and conforming to ${STRING_GENERAL}. The ${ZSTRING} class (alias for ${EL_ZSTRING}) has many additional routines not found in ${STRING_32}, as for example: Python like tuple substitution.

**See Articles**


* [https://www.eiffel.org/blog/finnianr/zstring_released_in_eiffelloop_131 ZSTRING released in Eiffel-Loop 1.3.1]
* [https://www.eiffel.org/blog/finnianr/introducing_class_zstring Introducing class ZSTRING]
* [https://www.eiffel.org/article/iso8859_is_dead_long_live_iso8859 ISO-8859 is dead, long live ISO-8859]

**Benchmarks ${ZSTRING} vs ${STRING_32}**


* [./benchmark/ZSTRING-benchmarks-latin-1.html Base character-set Latin-1]
* [./benchmark/ZSTRING-benchmarks-latin-15.html Base character-set Latin-15]
## Image Utilities
Image utilities providing:


1. SVG to PNG conversion using C library [http://librsvg.sourceforge.net/ librsvg]
2. Miscellaneous routines from the [https://cairographics.org/ Cairo graphics C library]
## Installer Vision-2 GUI
A graphical user-interface for installing and uninstalling applications using Vision-2 and Vision-2-x components

Includes a special user interface to provide an accurate determination of the display size for Windows users. The user is asked to resize a window to the size of an A5 piece of paper.
## XHTML Viewer
A basic XHTML text renderer based on the [https://www.eiffel.org/files/doc/static/17.05/libraries/vision2/ev_rich_text_flatshort.html EV_RICH_TEXT] component found in the [https://www.eiffel.org/doc/solutions/EiffelVision_2 EiffelVision2 library].

It was used to create the help system in the [http://myching.software My Ching software] with page content authored in the Thunderbird email client and then exported as XHTML.

See class ${EL_HTML_TEXT} below for supported XHTML tags. This component facilitates the creation of a hyperlinked contents side bar in a split window.
## Vision2-X UI Container Extensions
Window, dialogs and other widget-container extensions for the [EiffelVision2](https://www.eiffel.org/resources/libraries/eiffelvision2) library.

**Container Descendants**


````
EV_CONTAINER*
	${EV_CELL}
		${EV_VIEWPORT}
			${EV_SCROLLABLE_AREA}
				${EV_TOP_LEFT_SCROLLABLE_AREA}
			${EL_CENTERED_VIEWPORT}
		${EV_WINDOW}
			${EV_TITLED_WINDOW}
				${EV_DIALOG}
					${EV_UNTITLED_DIALOG}
						${EL_PROGRESS_DIALOG}
					${EV_MESSAGE_DIALOG}
						${EV_CONFIRMATION_DIALOG}
							${EL_CONFIRMATION_DIALOG}
								${EL_SAVE_CHANGES_CONFIRMATION_DIALOG}
								${EL_APPLY_CHANGES_CONFIRMATION_DIALOG}
						${EV_INFORMATION_DIALOG}
							${EL_INFORMATION_DIALOG}
						${EV_WARNING_DIALOG}
							${EL_LOCALE_WARNING_DIALOG}
						${EV_ERROR_DIALOG}
							${EL_ERROR_DIALOG}
						${EL_MESSAGE_DIALOG}
							${EL_CONFIRMATION_DIALOG}
							${EL_ERROR_DIALOG}
							${EL_INFORMATION_DIALOG}
				${EL_TITLED_WINDOW}
					${EL_TITLED_TAB_BOOK_WINDOW}
					${EL_TITLED_WINDOW_WITH_CONSOLE_MANAGER}*
		${EV_MODEL_WORLD_CELL}
			${EL_MODEL_WORLD_CELL}
		${EV_FRAME}
			${EL_FRAME} [B -> ${EL_BOX} create make end]
		${EL_EXPANDED_CELL}
	${EV_WIDGET_LIST}*
		${EV_BOX}*
			${EV_HORIZONTAL_BOX}
				${EL_DIRECTORY_USER_SELECT}
				${EL_HORIZONTAL_BOX}
					${EL_DATE_INPUT_BOX}
					${EL_CONSOLE_MANAGER_TOOLBAR}
					${EL_SCROLLABLE_BOX} [B -> ${EL_BOX} create make end]
						${EL_SCROLLABLE_PAGE}
						${EL_SCROLLABLE_VERTICAL_BOX}
							${EL_SCROLLABLE_SEARCH_RESULTS} [G]
								${EL_SCROLLABLE_WORD_SEARCHABLE_RESULTS} [G -> ${EL_WORD_SEARCHABLE}]
					${EL_AUTO_CELL_HIDING_HORIZONTAL_BOX}
					${EL_CENTERED_VERTICAL_BOX}
					${EL_PROGRESS_METER}
					${EL_MULTI_MODE_HTML_COLOR_SELECTOR_BOX}
			${EV_VERTICAL_BOX}
				${EL_TOOL_BAR_RADIO_BUTTON_GRID}
				${EL_DOCKED_TAB_BOOK}
					${EL_SPLIT_AREA_DOCKED_TAB_BOOK}
				${EL_VERTICAL_BOX}
					${EL_AUTO_CELL_HIDING_VERTICAL_BOX}
					${EL_WIDGET_PROGRESS_BOX} [W -> ${EV_WIDGET} create default_create end]
						${EL_BUTTON_PROGRESS_BOX} [B -> ${EV_BUTTON} create default_create end]
					${EL_PASSPHRASE_RATING_TABLE}
			${EL_BOX}*
				${EL_HORIZONTAL_BOX}
				${EL_VERTICAL_BOX}
				${EL_AUTO_CELL_HIDING_BOX}*
					${EL_AUTO_CELL_HIDING_HORIZONTAL_BOX}
					${EL_AUTO_CELL_HIDING_VERTICAL_BOX}
		${EV_NOTEBOOK}
			${EL_FIXED_TAB_BOOK}* [W -> ${EV_POSITIONABLE}]
			${EL_TAB_BOOK} [B -> ${EL_BOX} create make end]
		${EV_FIXED}
			${EL_MIXED_STYLE_FIXED_LABELS}
````

## Vision2-X UI Extensions
Various extensions for the [EiffelVision2](https://www.eiffel.org/resources/libraries/eiffelvision2) library.
## Vision2-X 2D Graphics
Classes for 2D geometry and graphical drawing
## Pango-Cairo 2D Graphics
Eiffel interface to the [Cairo 2D graphics library](https://cairographics.org/) providing pixel buffer rendering with transparencies and anti-aliasing.
## Vision2-X Pixmap Extensions
Classes for managing pixmaps
## Vision2-X UI Widget Extensions
Widget extensions for the [EiffelVision2](https://www.eiffel.org/resources/libraries/eiffelvision2) library

**Drop-down Combo Boxes**


* Drop-downs linked to data containers conforming to [https://www.eiffel.org/files/doc/static/trunk/libraries/base/finite_chart.html](FINITE [G]) and initialized with a value of type `G`, and a selection change agent of type [https://www.eiffel.org/files/doc/static/trunk/libraries/base/procedure_chart.html](PROCEDURE [G]). See class [http://www.eiffel-loop.com/library/graphic/toolkit/vision2-x/widget/item-list/el_drop_down_box.html](EL_DROP_DOWN_BOX)
* Drop-downs with localized display strings. See class [http://www.eiffel-loop.com/library/graphic/toolkit/vision2-x/widget/item-list/el_locale_zstring_drop_down_box.html](EL_LOCALE_ZSTRING_DROP_DOWN_BOX)
* Drop downs for months of year specified as integers and displayed with English names and a localized variant [http://www.eiffel-loop.com/library/graphic/toolkit/vision2-x/widget/item-list/el_locale_zstring_drop_down_box.html](EL_LOCALE_ZSTRING_DROP_DOWN_BOX)

** Primitive Widget Descendants**


````
EV_PRIMITIVE*
	${EV_TEXT_COMPONENT}*
		${EV_TEXT_FIELD}
			${EV_COMBO_BOX}
				${EL_COMBO_BOX}
					${EL_DROP_DOWN_BOX} [G]
						${EL_MONTH_DROP_DOWN_BOX}
						${EL_ZSTRING_DROP_DOWN_BOX}
							${EL_LOCALE_ZSTRING_DROP_DOWN_BOX}
			${EL_TEXT_FIELD}
				${EL_INPUT_FIELD}* [G]
					${EL_INTEGER_INPUT_FIELD}
		${EV_TEXT}
			${EV_RICH_TEXT}
				${EL_RICH_TEXT}
			${EL_TEXT}
		${EL_TEXT_COMPONENT}*
			${EL_UNDOABLE_TEXT_COMPONENT}*
				${EL_TEXT}
				${EL_TEXT_FIELD}
	${EV_LABEL}
		${EL_LABEL}
			${EL_WRAPPED_LABEL}
	${EV_TOOL_BAR}
		${EL_SHARED_RADIO_GROUP_TOOL_BAR}
	${EV_DRAWING_AREA}
		${EL_BUSY_PROCESS_ANIMATION}
		${EL_RED_GREEN_STATUS_LIGHTS_DRAWING_AREA}
		${EL_TIMED_PROGRESS_BAR}
		${EL_DRAWING_AREA_BASE}*
			${EL_DRAWING_AREA}
				${EL_DRAWING_AREA_LABEL}
			${EL_CHECK_AREA}
			${EL_MIXED_FONT_LABEL_AREA}
			${EL_HYPERLINK_AREA}
		${EL_PROGRESS_BAR}
	${EV_PIXMAP}
		${EL_BUTTON_PIXMAP}
		${EL_PIXMAP}
			${EL_DRAWING_PIXMAP}*
				${EL_LABEL_PIXMAP}
			${EL_SVG_PIXMAP}
				${EL_SVG_TEMPLATE_PIXMAP}
					${EL_STRETCHABLE_SVG_TEMPLATE_PIXMAP}
	${EV_GAUGE}*
		${EV_SCROLL_BAR}*
		${EV_RANGE}*
			${EV_VERTICAL_RANGE}
				${EL_SCALE_SLIDER}
		${EV_SPIN_BUTTON}
	${EV_BUTTON}
		${EV_TOGGLE_BUTTON}
			${EV_CHECK_BUTTON}
				${EL_CHECK_BUTTON}
			${EL_TOGGLE_BUTTON}
		${EL_BUTTON}
			${EL_PIXMAP_BUTTON}
			${EL_DECORATED_BUTTON}
		${EL_COLOR_BUTTON}
## Windows Eiffel Library Extensions
Extensions for [https://www.eiffel.org/doc/solutions/WEL WEL GUI library].
## C and C++
Support creation of Eiffel interfaces to C and C++ API's
## MS Component Object Model
Eiffel interfaces to some basic Microsoft Component Object Model classes including:


* IPersistFile
* IShellLinkW
## Java
A high-level framework for wrapping Java classes that adds a useful layer of abstraction to Eiffel Software's interface to the JNI ([https://en.wikipedia.org/wiki/Java_Native_Interface Java Native Interface]) called [https://www.eiffel.org/doc/solutions/Eiffel2Java eiffel2java].

**Features**
* Better Java environment discovery for initialization.
* Automates composition of JNI call signature strings.
* Automates cleanup of Java objects.

The framework is based on the concept of a Java agent that is similar to an Eiffel agent. You will find classes: ${JAVA_FUNCTION} and ${JAVA_PROCEDURE} that inherit ${JAVA_ROUTINE}. These agent classes automatically generate correct JNI call signatures. The library allows the creation of recursively wrapped classes where the arguments and return types to wrapped routines are themselves wrapped classes.

See [./example/eiffel2java/eiffel2java.html example/eiffel2java/eiffel2java.ecf] for an example of it's use.
## Python Interface
Some extensions to Daniel RodrÃ­guez's [https://github.com/finnianr/Eiffel-Loop/tree/master/contrib/Eiffel/PEPE PEPE library for Eiffel]. This library allows you to call Python objects from Eiffel. Here is one example to query ID3 tags in an MP3 file: ${EL_EYED3_TAG}.
## Matlab
**Status:** No longer maintained

An Eiffel interface to [http://uk.mathworks.com/products/matlab/ Matlab], a popular math orientated scripting language. This interface was developed with Matlab Version 6.5, VC++ 8.0 Express Edition and Windows XP SP2 and successfully used in a number of linguistic research projects.

**NOTE** This ECF is for documentation purposes only and will not compile.
## Praat-script
**Status:** No longer maintained

Eiffel interface to the Praat scripting language

[http://www.fon.hum.uva.nl/praat Praat] is a free tool for doing acoustic and phonetic analysis and has it's own scripting language, Praat-script.

The `el_toolkit' utility has an option for converting the source code of Praat ver. 4.4 to compile with MSC. (Praat compiles "out of the box" with the mingw compiler, but at the time EiffelStudio didn't support mingw)

Developed with VC++ 8.0 Express Edition, Windows XP SP2, Praat source code version 4.4.30. The conversion tool will not work with later versions of Praat.

**NOTE** This ECF is for documentation purposes only and will not compile.
## Eiffel Remote Object Server (EROS)
EROS (for **E**iffel **R**emote **O**bject **S**erver), is an experimental an XML orientated remote procedure call application framework with an original protocol based purely on XML processing instructions rather that any special XML tags.

**Custom Variables**

When including `eros.ecf' in your project it is necessary to define a custom variable `eros_server_enabled'. To build a server application set the value to `true'. To build a client application set value to `false'.

**Features**


* Easily create multi threaded XML-RPC applications in Eiffel.
* Allows standard XML documents (SVG, XHTML etc) to be turned into procedure calls with the addition of a single processing instruction.
* Based on framework that allows flexible mapping of XML data to native Eiffel objects. Represent your XML data in Eiffel any way you want. The fact that you only need to include as much data as you need makes it much more efficient than a DOM based approach.
* Deserialization (XML->Eiffel) uses declarative xpath to setter mapping arrays. Multi context mapping greatly simplifies deserialization of complex documents by eliminating the need for absolete XPaths. Instead a small number of XML contexts are defined and attribute mappings use relative xpaths.
* Serialization (Eiffel->XML) uses [./library/evolicity.html Evolicity] the Eiffel Loop templating mini-language. Evolicity is similar to [http://velocity.apache.org/ Apache Velocity] but supports multi-context serialization. This greatly simplifies serialization of complex Eiffel structures.
* Remotely accessible application components can be developed initially with a single threaded console test harness, and then later deployed on multi-threaded server with thread output and performance monitor.
* A server GUI controls startup/shutdown and thread log output context switching in command console. Context switching has browser like navigation controls and allows you to easily monitor a large number of threads.
* The server GUI monitors 11 different performance characteristics.

**Demo Applications**

Two demo applications are provided that do signal math including Fourier transformations based on Greg Lee's [https://teameiffel.blogspot.com/2006/04/greg-lees-numeric-eiffel-library.html Numeric Eiffel Library].


1. [./example/net/EROS/signal-math/signal-math.html signal-math.ecf] is a multi-mode command-line application with 2 client modes and 2 server-test modes.
2. [./example/net/EROS/server/signal-math-server.html signal-math-server.ecf] performs the same calculations as the server mode of demo 1 but is multi-threaded and has a graphical user interface to control the thread logging context visible in terminal console.
## Networking Common
Common networking classes


* Extensions for ISE network sockets.
* Class to obtain the MAC address of network devices on both Windows and Linux.
* Classes for managing HTTP cookies, query parameters, headers and status codes.
* FTP upload and download
## Adobe Flash to Laabhair
**Status:** No longer maintained

Eiffel network interface to [https://github.com/finnianr/Eiffel-Loop/blob/master/Flash_library/eiffel_loop/laabhair Flash ActionScript objects] used in the **Laabhair** digital signal processing framework. This framework allows you to create applications that process speech with a [http://www.fon.hum.uva.nl/praat Praat] script in real time and create visual representations of the the data using Adobe Flash. Depends on the Eiffel-Loop Praat-script interface library.

Developed on Windows XP SP2 with Flash Professional 8 IDE, EiffelStudio 6.1, VC++ 8.0 Express Edition.

Laabhair was developed at the [https://arrow.dit.ie/dmc/ Digital Media Centre at the Dublin Institute of Technology]
## Amazon Instant Access API
An Eiffel interface to the [https://s3-us-west-2.amazonaws.com/dtg-docs/index.html Amazon Instant Access API]. This API enables third party vendors to fulfil orders for digital goods on the Amazon store. It enables One-time purchases but not subscriptions. It passes a basic test suite but has not yet been tested in production.
## PayPal Payments Standard Button Manager API
An Eiffel interface to the [http://web.archive.org/web/20171124085630/https://developer.paypal.com/docs/classic/button-manager/integration-guide/ PayPal Payments Standard Button Manager NVP HTTP API]. (Now deprecated by Paypal)
## HTTP Client Services
Classes for remotely interacting with a HTTP server. Supports the HTTP commands: POST, GET and HEAD.
## Fast CGI Protocol
This implemenation of the [http://www.mit.edu/~yandros/doc/specs/fcgi-spec.html Fast CGI protocol] allows you to create Fast-CGI services that service HTTP requests forwarded by a web server via a local network socket.

Each service implements a table of servlets to service particular requests. The service is configured from a Pyxis format configuration file and listens either on a port number or a Unix socket for request from the web server.

This API has been tested in production with the [https://cherokee-project.com/ Cherokee Web Server] Ver. 1.2.101
## HTTP Servlet Services
Some basic HTTP services implemented using the [./library/fast-cgi.protocol.html Fast-CGI API] including:


* IP address echo
* Anti-hacking service that can used to block IP addresses of malicious attack sources.
## Override of EiffelVision2
Override of Eiffel Software's EiffelVision2 for use with [./library/vision2-x.html Eiffel-Loop Vision2 extensions]
## Override of Eiffel2Java
Override of Eiffel Software's [https://www.eiffel.org/doc/solutions/Eiffel2Java Eiffel2Java] library for use with the [./library/eiffel2java.html  Eiffel-Loop Eiffel to Java] library.
## Document Node-scanning and Object Building
A set of abstractions for scanning the nodes of an XML-like document without any commitment to a particular document syntax. Parsers to generate events are provided by separate libraries.

Provides:


* Document node scanning with mapping of xpath expressions to agent handler procedures.
* Recursive building of Eiffel objects from document data using context-relative Xpath expressions.
* Reflective capabilities for documents with element or atttribute names that match Eiffel class attributes.

Base library for:


* [XML Document Node-scanning and Object Building library](http://www.eiffel-loop.com/library/xml-scan.html)
* [Pyxis Document Node-scanning and Object Building library](http://www.eiffel-loop.com/library/pyxis-scan.html)

**XML Node Scanning**

The abstraction [http://www.eiffel-loop.com/library/persistency/document/scanner/event-source/el_parse_event_source.html](EL_PARSE_EVENT_SOURCE) representing a parse-event source has 5 useful descendants:


````
EL_PARSE_EVENT_SOURCE*
	${EL_BINARY_ENCODED_PARSE_EVENT_SOURCE}
	${EL_EXPAT_XML_PARSER}
		${EL_EXPAT_XML_PARSER_OUTPUT_MEDIUM}
		${EL_EXPAT_XML_WITH_CTRL_Z_PARSER}
		${EL_EXPAT_XHTML_PARSER}
	${EL_DEFAULT_PARSE_EVENT_SOURCE}
	${EL_PYXIS_PARSER}
````
Class [http://www.eiffel-loop.com/library/persistency/document/scanner/event-source/el_binary_encoded_parse_event_source.html](EL_BINARY_ENCODED_PARSE_EVENT_SOURCE) is a binary encoded XML event source, useful for reducing the size of large documents for transfer across a network.

The following are the various kinds of scanners which can process the output from these event sources.

**Eiffel Object Building Scanners**

The classes [http://www.eiffel-loop.com/library/persistency/xml/doc-scan/buildable/el_buildable_from_xml.html](EL_BUILDABLE_FROM_XML) and [http://www.eiffel-loop.com/library/persistency/pyxis-doc/buildable/el_buildable_from_pyxis.html](EL_BUILDABLE_FROM_PYXIS) can be used to implement a sophisticated Eiffel object building scheme based on the idea of mapping builder agents to xpaths relative to particular element contexts. Only a small subset of the xpath standard is used. The framework has the following features:


* Map particular XML element contexts to Eiffel classes and then map xpaths that are relative to these elements, to attribute assigning agents.
* Supports xpath mapping based on attribute value predicates, i.e. Expressions of the form **AAA/BBB[@x='y']** may be used to map building agents.
* Supports recursive data models.

**General Xpath to Eiffel agent mapper**

The class [http://www.eiffel-loop.com/library/persistency/document/createable/el_createable_from_xpath_match_events.html](EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS) implements a method for scanning a document and triggering various Eiffel agents according to a table of xpath to agent mappings.

**Eiffel Aware Document Scanner**

The class [http://www.eiffel-loop.com/library/persistency/document/createable/el_smart_buildable_from_node_scan.html](EL_SMART_BUILDABLE_FROM_NODE_SCAN) is an XML parser that reacts to a special XML processing instruction, telling it to build an Eiffel object of a particular type.
## Eco-DB (Eiffel CHAIN Orientated Database)
**DEPENDS**


* Eiffel-Loop base.ecf
* [document-scan.ecf](http://www.eiffel-loop.com/library/document-scan.html)
* [Eiffel-Loop encryption.ecf](http://www.eiffel-loop.com/library/encryption.html)
* [pyxis-scan.ecf](http://www.eiffel-loop.com/library/pyxis-scan.html)
* [text-formats.ecf](http://www.eiffel-loop.com/library/text-formats.html)

**INTRODUCTION**

*Eco-DB* is an acronym for **E**iffel **C**HAIN **O**rientated **D**atabase, so called because it allows the extension by inheritance of a container conforming to [https://www.eiffel.org/files/doc/static/trunk/libraries/base/chain_chart.html](CHAIN) to assume many of the characteristics of a relational database table. *Eco-DB* leverages many of the facilities of the [reflection cluster](http://www.eiffel-loop.com/library/base/base.reflection.html) from the Eiffel-Loop base library, allowing class attributes to be managed as data table fields.

Some of the main features of this database system are as follows:

**1.** Perform the normal database [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) operations.

**2.** Table joins, meaning a field in one [https://www.eiffel.org/files/doc/static/trunk/libraries/base/chain_chart.html](CHAIN [G]) table can be used to look up a row-item in another using a hash table index. A supporting feature is the ability to generate indexed primary keys in an automated fashion.

**3.** Option to store data securely using [AES encryption](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard).

**4.** Database fields are defined as class attributes and are managed reflectively, but there is also a manual method for writing and reading.

**5.** A simple centralised method to specify which fields should maintain a hash index for fast row look-ups by field value. A caveat is it only useful for unique id fields, like email addresses for examples.

**6.** Powerful Eiffel-orientated query facility that leverages the Eiffel conjunctive, disjunctive and negated keywords. Can also be used with [https://www.eiffel.org/files/doc/static/trunk/libraries/base/predicate_chart.html](PREDICATE) agents.

**7.** Leverages a feature of the [reflection cluster](http://www.eiffel-loop.com/library/base/base.reflection.html) to link selected fields of an expanded type to a textual representation, as defined for example by a [https://www.eiffel.org/files/doc/static/trunk/libraries/time/date_chart.html](DATE) or ${EL_ENUMERATION [N -> NUMERIC]} object. This is important when it comes to importing or exporting tables to/from a human readable form, or for setting the fields reflectively from a string based source.

**8.** Contract support to protect database integrity by the inclusion of a CRC check-sum for each [https://www.eiffel.org/files/doc/static/trunk/libraries/base/chain_chart.html](CHAIN) table. This guards against accidental changes of field type, field order, field name or textual representation.

**9.** Facility to export a meta-data record of the precise definition of the persistent data structure as a pseudo-Eiffel class. See for example: [myching.software-meta-data.tar.gz](http://www.eiffel-loop.com/download/myching.software-meta-data.tar.gz)

**10.** Fully automated import/export of [https://www.eiffel.org/files/doc/static/trunk/libraries/base/chain_chart.html](CHAIN) tables in either CSV or [Pyxis format](https://www.eiffel.org/node/143) (an XML analogue with superior readability). This can be used as a very safe form of backup allowing data to be re-imported even if the field order has changed. The [Pyxis format](https://www.eiffel.org/node/143) is very compact and readable allowing easy manual inspection of data. The [gedit](https://en.wikipedia.org/wiki/Gedit) text editor has syntax highlighting for this format. See for example: [payment.pyx](http://www.eiffel-loop.com/download/payment.pyx) recording Paypal transactions.

**11.** Unlike a relational database, the data rows of a [https://www.eiffel.org/files/doc/static/trunk/libraries/base/chain_chart.html](CHAIN) table do not have to be flat, since class attributes in a store-able item, can themselves be declared to be store-able. For example class [http://www.eiffel-loop.com/library/text/encryption/hash/el_uuid.html](EL_UUID) (inheriting [https://www.eiffel.org/files/doc/static/trunk/libraries/uuid/uuid_chart.html](UUID)) can be a storable attribute, which itself is reflectively stored as 5 integer attributes of various types.

**12.** Application version awareness allows data to be migrated from a data table created by an earlier software version.

**13.** Has been used in production for an [online shop](http://myching.software/) to store details of software subscription sales via Paypal. It is also used very reliably in the [My Ching software](http://myching.software) application to manage a journal of I Ching readings and store localization information. In fact *My Ching* was one of the main drivers for development of this library.

**PERSISTENCE**

Of course this is the fundamental property of any database. *Eco-DB* offers 2 kinds of persistence:

**1. CHAIN level persistence**

This type of persistence involves storing the entire chain to a file in one operation. This is useful for data that is more or less static, like for example the localisation table [http://www.eiffel-loop.com/library/text/i18n/support/el_translation_items_list.html](EL_TRANSLATION_ITEMS_LIST). 

See class [http://www.eiffel-loop.com/library/persistency/database/eco-db/chain/ecd_chain.html](ECD_CHAIN).

**2. item level persistence**

Item level, or "incremental persistence" is where the effects of any of the basic [https://www.eiffel.org/files/doc/static/trunk/libraries/base/chain_chart.html](CHAIN) operations `(extend/replace/delete**)` are recorded as they happen in a separate editions file. When the chain is loaded during object initialisation, a chain level store is loaded first, and then the stored editions are applied to bring the chain to it's final state.

See class [http://www.eiffel-loop.com/library/persistency/database/eco-db/chain/ecd_recoverable_chain.html](ECD_RECOVERABLE_CHAIN) for more details.

**TABLE JOINS**

Being able to join*** tables via a common field is the essence of a relational database. *Eco-DB* offers a number of features that support the joining of chains.

**1. Field Indexing** 

For a large number of chain items, performing joins can be slow without the use of field indices. *Eco-DB* offers an easy way to maintain field indices with very little code via the implementing class [http://www.eiffel-loop.com/library/persistency/database/eco-db/chain/ecd_arrayed_list.html](ECD_ARRAYED_LIST [EL_STORABLE]) which does all the work of maintaining the index. To index selected fields you just need to redefine the function *new_index_by* found in [http://www.eiffel-loop.com/library/persistency/database/eco-db/chain/ecd_arrayed_list.html](ECD_ARRAYED_LIST) as in this example:


````
class
	SUBSCRIPTION_LIST
````

````
inherit
	ECD_ARRAYED_LIST [SUBSCRIPTION]
		rename
			item as subscription_item
		redefine
			new_index_by
		end
````

````
feature {NONE} -- Factory
````

````
	new_index_by: TUPLE [machine_id: like new_index_by_string_8; activation_code: like new_index_by_uuid]
		do
			create Result
			Result.machine_id := new_index_by_string_8 (agent machine_id_index)
			Result.activation_code := new_index_by_uuid (agent {SUBSCRIPTION}.activation_code)
		end
````

````
feature {NONE} -- Implementation
````

````
	machine_id_index (subsription: SUBSCRIPTION): STRING
		do
			if subsription.is_expired then
				create Result.make_empty
			else
				Result := subsription.machine_id
			end
		end
````
And here is an example showing how to use the created index:


````
class SUBSCRIPTION_LIST
````

````
feature -- Status query
````

````
	is_subscription_current (activation_code: EL_UUID): BOOLEAN
		do
			if attached index_by.activation_code as table then
				table.search (activation_code)
				if table.found then
					Result := table.found_item.is_current
				end
			end
		end
````
**2. Primary Keys**

Being able to assign a unique identifier to each item in a chain is essential to creating many kinds of data-joins. *Eco-DB* offers a convenient way to both generate primary keys and maintain an index for it. This is achieved with the auxiliary class [http://www.eiffel-loop.com/library/persistency/database/eco-db/index/ecd_primary_key_indexable.html](ECD_PRIMARY_KEY_INDEXABLE [EL_KEY_IDENTIFIABLE_STORABLE]) when used in conjunction with [http://www.eiffel-loop.com/library/persistency/database/eco-db/chain/ecd_arrayed_list.html](ECD_ARRAYED_LIST [EL_STORABLE]). The class parameter implies that the storable item must conform to [http://www.eiffel-loop.com/library/persistency/file/store/id/el_key_identifiable_storable.html](EL_KEY_IDENTIFIABLE_STORABLE). Generation of primary key values is automatic when the list is extended, as is maintenance of the primary key hash-table index.

**QUERY LANGUAGE**

Of course the Eiffel language itself can be used to query any [https://www.eiffel.org/files/doc/static/trunk/libraries/base/chain_chart.html](CHAIN) list, but sometimes the meaning of the query is obscured in implementation details. What is needed is a slightly more abstract way of expressing queries that makes the meaning more apparent. This is provided by the class [http://www.eiffel-loop.com/library/base/data_structure/list/queryable/el_queryable_chain.html](EL_QUERYABLE_CHAIN) and it's helper [http://www.eiffel-loop.com/library/base/data_structure/list/queryable/el_query_condition_factory.html](EL_QUERY_CONDITION_FACTORY). The implementing class [http://www.eiffel-loop.com/library/persistency/database/eco-db/chain/ecd_arrayed_list.html](ECD_ARRAYED_LIST) inherits [http://www.eiffel-loop.com/library/base/data_structure/list/queryable/el_queryable_chain.html](EL_QUERYABLE_CHAIN).

Conditions can be combined using the logical operators: **and**, **or** and **not** as in this example from class [http://www.eiffel-loop.com/example/manage-mp3/source/rhythmbox/manager/task/manage/collate_songs_task.html](COLLATE_SONGS_TASK) found in project [Eiffel-Loop/example/manage-mp3](http://www.eiffel-loop.com/example/manage-mp3/manage-mp3.html).


````
apply
	-- sort mp3 files into directories according to genre and artist set in Rhythmbox music library Database.
	-- Playlist locations will be updated to match new locations.
	local
		new_mp3_path: EL_FILE_PATH; song: RBOX_SONG; query_result: LIST [RBOX_SONG]
	do
		query_result := Database.existing_songs_query (not (song_is_cortina or song_has_normalized_mp3_path))
		if query_result.is_empty then
			lio.put_line ("All songs are normalized")
		else
			across query_result as query loop
				song := query.item
				..
			end
		end
	end
````
The routine *existing_songs_query* passes a modified form of the query to *songs* list.


````
existing_songs_query (condition: EL_QUERY_CONDITION [RBOX_SONG]): like songs.query
	do
		Result := songs.query (not song_is_hidden and condition)
	end
````

````
songs: EL_QUERYABLE_ARRAYED_LIST [RBOX_SONG]
````
The query atoms *song_is_cortina* and *song_has_normalized_mp3_path* are defined in class [http://www.eiffel-loop.com/example/manage-mp3/source/rhythmbox/database/song_query_conditions.html](SONG_QUERY_CONDITIONS) which is defined as follows


````
class
	${SONG_QUERY_CONDITIONS}
````

````
inherit
	${EL_QUERY_CONDITION_FACTORY} [RBOX_SONG]
		rename
			any as any_song
		export
			{NONE} all
		end
````
**META-DATA EXPORT**

The routine *export_meta_data* in class [http://www.eiffel-loop.com/library/persistency/database/eco-db/chain/ecd_reflective_recoverable_chain.html](ECD_REFLECTIVE_RECOVERABLE_CHAIN) stores in a versioned directory the precise specification of the data layout, including the correct order, field types and names. The specification is formatted as pseudo Eiffel code so it can be easily viewed in an editor equipped with Eiffel syntax highlighting.

See for example: [myching.software-meta-data.tar.gz](http://www.eiffel-loop.com/download/myching.software-meta-data.tar.gz) (missing the version directory)

**IMPORT/EXPORT**

It is important to have a way to backup data that offer some degree of independence from the precise binary data structure for the purpose of replacing data with data from another software version, which may have fields stored in a different order, or types etc. *Eco-DB* supports two export formats:


1. **CSV** or Comma Separated Values if the data is flat, i.e. all the fields are basic types and are not compound types conforming to either [http://www.eiffel-loop.com/library/base/persistency/storable/el_storable.html](EL_STORABLE) or  [https://www.eiffel.org/files/doc/static/trunk/libraries/base/tuple_chart.html](TUPLE).


2. [Pyxis format](https://www.eiffel.org/node/143) which is very readable and compact. Shorter fields are grouped together as attributes on separate lines. See for example: [payment.pyx](http://www.eiffel-loop.com/download/payment.pyx) which is a record of Paypal transactions.

The relevant class for importing or exporting is [http://www.eiffel-loop.com/library/persistency/database/eco-db/chain/ecd_reflective_recoverable_chain.html](ECD_REFLECTIVE_RECOVERABLE_CHAIN)

**VERSION MANAGEMENT**

A record of the software version is stored in each table. By defining procedure *read_version* from class [http://www.eiffel-loop.com/library/base/persistency/storable/el_storable.html](EL_STORABLE)


````
read_version (a_reader: EL_MEMORY_READER_WRITER; version: NATURAL)
	deferred
	end
````
it is possible to migrate data written by an earlier version of the software. If this is not required, this routine can be renamed to *read_default_version* in the inheritance section.

**A DATABASE ABSTRACTION**

There is work in progress to create an abstraction representing the concept of a database i.e. a collection of related tables. Currently this exists only in the form of an application library for the [myching.software](http://myching.software) shop server. More work is needed to create useful abstractions that can be added to the *Eco-DB* library.

A preview of classes which will form the basis of reusable abstractions are as follows:


* [DATABASE](http://www.eiffel-loop.com/download/database.e) contains fields conforming to DATA_TABLE and various routines that operate on all the tables at once. For example: make_open, close, delete, backup, export_as_pyxis etc
* [DATABASE_CONFIG](http://www.eiffel-loop.com/download/database_config.e) for storing/reading the database credentials etc.
* [DATA_TABLE](http://www.eiffel-loop.com/download/data_table.e) is an abstraction allowing thread safe table operations in a concurrent environment.
* [DATABASE_MANAGER_SHELL](http://www.eiffel-loop.com/download/database_manager_shell.e) is a menu driven shell for managing the database and performing operations like import, export, backup etc.
* [DATABASE_CREDENTIAL](http://www.eiffel-loop.com/download/database_credential.e) is an authenticated credential for opening an encrypted database.

**Foot Notes**

** `delete` is a routine from [http://www.eiffel-loop.com/library/persistency/database/eco-db/chain/ecd_chain.html](ECD_CHAIN) and not from [https://www.eiffel.org/files/doc/static/trunk/libraries/base/chain_chart.html](CHAIN).

*** We are using the term *join* somewhat loosely and mean only that if you have two chains *CHAIN [A]* and *CHAIN [B]*, you can produce a subchain of *CHAIN [B]* where each *B* item has a matching field value with an item from *CHAIN [A]*.
## File and Directory Data Processing
Class categories:


* Path environment variable setting
* Directory content processing to mirrored tree
* Comma separated value support
* File persistence and file deserialization
* Reflective persistence
* File swapping
* Unique identifier

## Kindle Publishing
Classes for generating Kindle OPF packages from HTML content.
## Thunderbird Email Export
Classes to read and export emails from the [Thunderbird email client](https://www.thunderbird.net/) including a class to generate a Kindle book from a folder of chapter emails.

Test class [Unknown-path](THUNDERBIRD_TEST_APP)
## Open Office Spreadsheets
Classes for reading the contents of [OpenDocument Flat XML spreadsheets](http://www.datypic.com/sc/odf/e-office_spreadsheet.html) using [VTD-XML](http://vtd-xml.sourceforge.net/).

Test class [Unknown-path](OPEN_OFFICE_TEST_APP)
## Pyxis Document Node-scanning and Object Building
Library for parsing and scanning documents in [Pyxis format](https://www.eiffel.org/node/143)

Provides:


* Pyxis document node scanning with mapping of xpath expressions to agent handler procedures.
* Recursive building of Eiffel objects from Pyxis data using context-relative Xpath expressions.
* Reflective building of Eiffel objects from Pyxis data with corresponding element and attribute names

Class [http://www.eiffel-loop.com/library/persistency/pyxis-doc/parser/el_pyxis_parser.html](EL_PYXIS_PARSER) generates events from a [Pyxis format](https://www.eiffel.org/node/143) parser. Pyxis is a direct analog of XML that is easier to read and edit making it suitable for configuration files.
## Eiffel LIST-orientated XML Database
**Status:** No longer maintained

(Last compiled November 2022)

A simple XML database based on VTD-XML xpath and XML parsing library. Supports transactions and encryption. Any list conforming to [https://www.eiffel.org/files/doc/static/trunk/libraries/base/list_chart.html](LIST [EL_STORABLE_XML_ELEMENT]) can be turned into a database. This library has now been superceded by [Eco-DB.ecf](http://www.eiffel-loop.com/library/Eco-DB.html) which is faster, more powerful and uses a binary format.
## XML Document Node-scanning and Object Building
Provides:


* XML node scanning with mapping of xpath expressions to agent handler procedures.
* Recursive building of Eiffel objects from XML data using context-relative Xpath expressions.
* Encryption credential persistence

**Parse Event Sources**

[http://www.eiffel-loop.com/library/persistency/xml/doc-scan/expat-parser/el_expat_xml_parser.html](EL_EXPAT_XML_PARSER)

An Eiffel binding to the [eXpat XML parser](http://expat.sourceforge.net/)

[http://www.eiffel-loop.com/library/persistency/xml/doc-scan/expat-parser/el_expat_xml_parser_output_medium.html](EL_EXPAT_XML_PARSER_OUTPUT_MEDIUM)

[eXpat XML parser](http://expat.sourceforge.net/) of XML serializeable objects conforming to [http://www.eiffel-loop.com/library/text/template/evolicity/serialization/evolicity_serializeable_as_xml.html](EVOLICITY_SERIALIZEABLE_AS_XML).

[http://www.eiffel-loop.com/library/persistency/xml/doc-scan/expat-parser/el_expat_xml_with_ctrl_z_parser.html](EL_EXPAT_XML_WITH_CTRL_Z_PARSER)

[eXpat XML parser](http://expat.sourceforge.net/) with input stream end delimited by Ctrl-Z character. Useful for parsing network streams.
## XML parsing and Xpath navigation with VTD-XML
Classes for scanning XML documents and building Eiffel objects from XML contexts defined by relative Xpaths. Based on the [VTD-XML parser](http://vtd-xml.sourceforge.net/). This is a full implemenation of Xpath 1.0.

VTD-XML uses a very fast and efficient method of building a compressed representation of an XML object using [virtual token descriptors](http://vtd-xml.sourceforge.net/VTD.html).

Using the Eiffel API is considerably easier and more intuitive to use than the original Java or C version of VTD-XML.

A substantial C-bridge was developed to make Eiffel work better with VTD-XML. The original VTX-XML code was forked to make it possible to compile it with the MSC compiler. This fork is found under `contrib/C`.

Test class [http://www.eiffel-loop.com/test/source/vtd-xml/apps/vtd_xml_autotest_app.html](VTD_XML_AUTOTEST_APP)
## Windows Registry Management
Classes for Windows registry searching, reading and editing.

This library adds a layer of abstraction to the Windows registry classes found the in the [Eiffel Windows Library WEL](https://www.eiffel.org/resources/libraries/wel). This abstraction layer makes it easier and more intuitive to search, read and edit Windows registry keys and data. See [this article](https://www.eiffel.org/article/windows_registry_access_made_easy) on Eiffel room.
## Multi-Application Management
This library has two main purposes:


1. Manage a collection of small (and possibility related) "mini-applications" as a single Eiffel application.
2. Implement the concept of a self-installing/uninstalling application on multiple-platforms.

**"Swiss-army-knife applications"**

Creating a new project application in Eiffel is expensive both in terms of time to create a new ECF and project directory structure, and in terms of diskspace. If all you want to do is create a small utility to do some relatively minor task, it makes sense to include it with a other such utilities in a single application. But you need some framework to manage all these sub-applications. In this package, the two classes [http://www.eiffel-loop.com/library/runtime/app-manage/multi-app/el_multi_application_root.html](EL_MULTI_APPLICATION_ROOT) and [Unknown-path](EL_SUB_APPLICATION) provide this capability.

**Command line sub-applications**

The following features exist for creating command line applications:


* The class [Unknown-path](EL_COMMAND_LINE_SUB_APPLICATION) provides a smart way of mapping command line arguments to the arguments of a creation procedure with automatic string conversion according to type.
* Built-in help system with usage help.
* Create menu driven command line shells.

**Installer Features**


* Define system menu entries and desktop shortcuts for both Windows and the Linux XDG desktop entry standard.
* Define application sub menus
* Define application menu launchers
* Define launcher as file context Nautilus action script. (A similar feature for Windows not yet implemented)
* Define dekstop menu icons
* Install application resources and program files
* Uninstall application resources and program files

**Resource Management**

The library provides a system of managing application resources like graphics, help files etc.


## Concurrency
Classes augmenting the classic [EiffelThread library](https://www.eiffel.org/doc/solutions/EiffelThreads).

**Work Distribution**

Classes [http://www.eiffel-loop.com/library/runtime/concurrency/communication/producer-consumer/distributer/el_procedure_distributer.html](EL_PROCEDURE_DISTRIBUTER) and [http://www.eiffel-loop.com/library/runtime/concurrency/communication/producer-consumer/distributer/el_function_distributer.html](EL_FUNCTION_DISTRIBUTER) offer a convenient way to distribute the work of executing routines using a specific number of cores. See routine `read_source_files` in class [http://www.eiffel-loop.com/tool/eiffel/source/root/eiffel/library/publish/config/file/eiffel_configuration_file.html](EIFFEL_CONFIGURATION_FILE) for an example.

**Producer-Consumer Framework**

A generic producer-consumer thread communication framework where a producing thread places products onto a queue for consumption by a consumer thread.

*Features*


* Implementation of a single consumer thread consuming the products of a single worker thread.
* Implementation of multiple consumer threads consuming the products of a single worker thread.
* Vision2 extension allowing products of a thread to be consumed by the main GUI application thread.
* Specialized consumer-producer thread classes for agent action consuming.

*Consumer Descendants*


````
${EL_CONSUMER}* [P]
	${EL_NONE_CONSUMER [P]}
	${EL_COUNT_CONSUMER}*
		${EL_COUNT_CONSUMER_MAIN_THREAD}*
			${EL_TIMED_PROCEDURE_MAIN_THREAD}
		${EL_TIMED_PROCEDURE}*
			${EL_TIMED_PROCEDURE_MAIN_THREAD}
			${EL_TIMED_PROCEDURE_THREAD}
		${EL_COUNT_CONSUMER_THREAD}*
			${EL_TIMED_PROCEDURE_THREAD}
	${EL_REGULAR_INTERVAL_EVENT_CONSUMER}*
		${EL_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER}*
		${EL_MAIN_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER}*
	${EL_CONSUMER_MAIN_THREAD}* [P]
		${EL_MAIN_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER}*
		${EL_COUNT_CONSUMER_MAIN_THREAD}*
		${EL_PROCEDURE_CALL_CONSUMER_MAIN_THREAD}
		${EL_ACTION_ARGUMENTS_CONSUMER_MAIN_THREAD} [ARGS -> ${TUPLE} create default_create end]
	${EL_PROCEDURE_CALL_CONSUMER}*
		${EL_PROCEDURE_CALL_CONSUMER_MAIN_THREAD}
		${EL_PROCEDURE_CALL_CONSUMER_THREAD}
	${EL_ACTION_ARGUMENTS_CONSUMER}* [ARGS -> ${TUPLE} create default_create end]
		${EL_ACTION_ARGUMENTS_CONSUMER_MAIN_THREAD} [ARGS -> ${TUPLE} create default_create end]
		${EL_ACTION_ARGUMENTS_CONSUMER_THREAD} [ARGS -> ${TUPLE} create default_create end]
			${EL_BATCH_FILE_PROCESSING_THREAD}*
				${EL_LOGGED_BATCH_FILE_PROCESSING_THREAD}*
	${EL_CONSUMER_THREAD}* [P]
		${EL_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER}*
		${EL_MANY_TO_ONE_CONSUMER_THREAD}* [P]
		${EL_ACTION_ARGUMENTS_CONSUMER_THREAD} [ARGS -> ${TUPLE} create default_create end]
		${EL_COUNT_CONSUMER_THREAD}*
		${EL_PROCEDURE_CALL_CONSUMER_THREAD}
		${EL_DELEGATING_CONSUMER_THREAD} [P, T -> ${EL_MANY_TO_ONE_CONSUMER_THREAD [P]} create make end]
````
*Product Queue Descendants*


````
EL_THREAD_PRODUCT_QUEUE [P]
	${EL_PROCEDURE_CALL_QUEUE}
	${EL_ONE_TO_MANY_THREAD_PRODUCT_QUEUE} [P, T -> ${EL_MANY_TO_ONE_CONSUMER_THREAD [P]} create make end]
````
**Specialized Threads**

The library includes many thread classes inheriting from [http://www.eiffel-loop.com/library/runtime/concurrency/thread-types/el_identified_thread_i.html](EL_IDENTIFIED_THREAD_I) that perform specialized tasks.

*Examples*


* Intermittently repeat an action with a specified sleep interval until signaled to stop.
* Continuously repeat an action until signaled to stop.
* Continuously repeat an action until receiving a signal to suspend or exit. Remains suspended unless signaled to resume or exit.

*Descendants*


````
EL_IDENTIFIED_THREAD_I*
	${EL_IDENTIFIED_MAIN_THREAD}
	${EL_IDENTIFIED_THREAD}*
		${EL_LOGGED_IDENTIFIED_THREAD}*
			${SIMPLE_SERVER_THREAD}
			${EROS_SERVER_THREAD}
		${EL_CONTINUOUS_ACTION_THREAD}*
			${EL_WORK_DISTRIBUTION_THREAD}
			${EL_DORMANT_ACTION_LOOP_THREAD}*
				${EL_REGULAR_INTERVAL_EVENT_PRODUCER}
			${EL_RHYTHMIC_ACTION_THREAD}*
				${EL_TIMED_COUNT_PRODUCER}
				${EL_TIMEOUT}
			${EL_CONSUMER_THREAD}* [P]
				${EL_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER}*
				${EL_MANY_TO_ONE_CONSUMER_THREAD}* [P]
				${EL_ACTION_ARGUMENTS_CONSUMER_THREAD} [ARGS -> ${TUPLE} create default_create end]
					${EL_BATCH_FILE_PROCESSING_THREAD}*
						${EL_LOGGED_BATCH_FILE_PROCESSING_THREAD}*
				${EL_COUNT_CONSUMER_THREAD}*
					${EL_TIMED_PROCEDURE_THREAD}
				${EL_PROCEDURE_CALL_CONSUMER_THREAD}
				${EL_DELEGATING_CONSUMER_THREAD} [P, T -> ${EL_MANY_TO_ONE_CONSUMER_THREAD [P]} create make end]
		${EL_WORKER_THREAD}
		${EL_FILE_PROCESS_THREAD}
			${EL_LOGGED_FILE_PROCESS_THREAD}
````
**Other Features**


* A Vision2 extension framework for building proxy interfaces to GUI components that are callable from non-GUI threads. Allows non-GUI threads to asynchronously call routines that call Vision2 routines.
* Intermittent timed event framework
* Container cell class for numeric types shared across threads. Features thread safe increment, decrement, add and subtract operations.
* Thread safe queue and stack container classes.


## Multi-threaded Logging
Logging library featuring color highlighted output and mimicry of Eiffel routine code in output.

**General Features**


* Output is indented to reflect the state of the call stack. Shows the entry and exit from routines in a way that is designed to mimic the routines code definition.


* On Unix platforms console output is syntax high-lighted by default. See this [screenshot](http://www.eiffel-loop.com/images/screenshot/color-highlighting.png).


* Global filtering mechanism to restrict output to selected classes and routines. A wildcard constant can be used to log all routines for a particular class.


* By implementing the [http://www.eiffel-loop.com/library/runtime/logging/support/el_console_manager.html](EL_CONSOLE_MANAGER) class in a GUI library it is possible to create a UI component that is able to switch the logged console output to that of a different thread of execution. The [Vision2-x library](http://www.eiffel-loop.com/library/vision2-x.html) has once such component [http://www.eiffel-loop.com/library/graphic/toolkit/vision2-x/container/cell/box/special/el_console_manager_toolbar.html](EL_CONSOLE_MANAGER_TOOLBAR). See this example [screenshot](http://www.eiffel-loop.com/images/screenshot/console-thread-switch.png). The [wel-x library](http://www.eiffel-loop.com/library/wel-x.html) partially implements it with class [http://www.eiffel-loop.com/library/graphic/toolkit/wel-x/logging/el_console_manager_dialog.html](EL_CONSOLE_MANAGER_DIALOG).

**Output Format**

The beauty of Eiffel-Loop logging is that the output is indented to show the entry and exit from routines. Each entry and exit to a routine is documented with a header and trailer output text based on the class name and routine name. The following is some sample output from a test program for the [Eiffel Loop VTD-XML API](http://www.eiffel-loop.com/library/vtd-xml.html). The test function executes an xpath query looking for http urls in an XML document.


````
1> JOBSERVE_SEARCH_APP.make
1>   doing
1>     
1>     JOBSERVE_SEARCHER.execute
1>       doing
1>         XPATH: "/job-serve/row[type/@value='Contract']"
1>         Position: PMO Analyst
1>         Duration: [180, 270]
1>         Position: Business Analyst (London Market)
1>         Duration: [180, 180]
1>         Position: SAP MM consultant- English
1>         Duration: [371, 371]
1>         Position: Oracle Hyperion Strategic Finance Management Consultant
1>         Duration: [180, 270]
1>         Saving to file: "/home/finnian/Desktop/jobserve.results.html"
1>         
1>       end -- JOBSERVE_SEARCHER
1>     
1>   end -- JOBSERVE_SEARCH_APP
1> 
````
Part of the code which produced the above output is as follows:


````
class
	JOBSERVE_SEARCHER
````

````
inherit
	EL_COMMAND
````

````
	EL_MODULE_LOG
````

````
feature -- Basic operations
````

````
	execute
		local
			jobs_result_set: JOBS_RESULT_SET; xpath: STRING
			root_node: EL_XPATH_ROOT_NODE_CONTEXT
		do
			log.enter ("execute")
			create root_node.make_from_file (xml_path)
			xpath := Xpath_template #$ [query_filter]
			log.put_string_field ("XPATH", xpath)
			log.put_new_line
			create jobs_result_set.make (root_node, xpath)
			across jobs_result_set as job loop
				lio.put_labeled_string ("Position", job.item.position)
				lio.put_new_line
				lio.put_integer_interval_field ("Duration", job.item.duration_interval)
				lio.put_new_line
			end
````

````
			log.put_path_field ("Saving to", results_path)
			log.put_new_line
			jobs_result_set.save_as_xml (results_path)
			log.exit
		end
````
Note that each logged routine must start and finish with a paired call to enter_with_args and exit and that the first argument to enter_with_args matches the name of the routine. The log object maintains a logging call stack. A call to enter_with_args pushes a new routine onto the stack and exit pops the entry. The second argument is of type [https://www.eiffel.org/files/doc/static/trunk/libraries/base/array_chart.html](ARRAY [ANY]) and is used to log any routine arguments. Routine enter_with_args calls the out function from the universal ancestor class `ANY` for each of the array items and lists them each on a separate line as argument (1), argument (2) etc.

**Comment on Java**

This type of logging would be difficult to implement in Java as multiple return instructions could appear anywhere in the routine. (Not that I haven't tried, in fact this framework originally started life as a Java framework) This is another argument in favor of languages like Eiffel which disallow arbitrary returns mid routine. Also Java is littered with all kinds of exception handling which greatly increases the number of exit paths from a routine (not to mention making the code more difficult to read). Eiffel has exception handling too but the philosophy of Eiffel is to head off unbridled use of exceptions by extensive debugging with the use of contracts instead of relying on exceptions to show you the bugs.

**Enter and exit variations**

A number of variations exist for the enter and exit procedures in the log object:

If you do not wish to log any routine arguments you can use the form:


````
log.enter ("test_bio_2")
````
If you wish to suppress the routine header and trailer output text you can use the form:


````
log.enter_no_header ("test_bio_2")
..
log.exit_no_trailer
````
**Managing exceptions**

In order to maintain the integrity of the logging routine stack it is important to balance every call to log.enter with a call `log.exit` on exiting a logged routine. However if your routine has a rescue clause and an exception occurs, these exit calls are skipped not only in the current routine but also in all sub routines before the point where the exception was thrown.  If you wish to recover from the exception by doing a routine retry you need a way to restore the logging routine stack back to what it was before the first `log.enter` call at the start of the routine. You can accomplish this by saving the state of the logging stack to a local variable before the log.enter call and use this variable to restore the logging stack in the rescue clause. The following code illustrates:


````
my_routine is
		-- Exception handling routine
	local
		log_stack_pos: INTEGER
	do
		log_stack_pos := log.call_stack_count
		log.enter ("my_routine")
		..
		log.exit
	rescue
		log.restore (log_stack_pos)
		..
		retry
	end
````
**Including logging in your application**

There are a number of ways to include logging in your application. The first is to inherit [Unknown-path](EL_LOGGED_SUB_APPLICATION) in your root class and implement the function `Log_filter` (see below). You must then make sure that init_logging is the first routine called in the application entry make procedure. A slightly simpler way is to inherit from class [Unknown-path](EL_SUB_APPLICATION) in your root class. This class has a make procedure already defined which calls init_logging, you only have to implement the procedures initialize and run. The routine make must be listed as a creation procedure.

Inheriting from class [Unknown-path](EL_SUB_APPLICATION) has some incidental benefits including:


* Graceful handling of the ctrl-c program interrupt with the possibility of putting application cleanup into a redefinition of procedure `on_operating_system_signal`.


* Integration with the Eiffel Loop multi mode application framework. This framework allows you to select from different applications by a command line switch. Useful for managing many small applications that hardly justify the disk resources of a separate project.

To including logging facilities in any class, inherit from class [http://www.eiffel-loop.com/library/runtime/logging/el_module_log.html](EL_MODULE_LOG) and add an entry for that class in the log filter array. (see below)

By default logging is not active in the application. It must be turned on using the `-logging` command line switch.

**Log output filtering**

The logging framework offers a simple way to filter the output by class and routine. The root class of your application should inherit class [Unknown-path](EL_LOGGED_SUB_APPLICATION) and implement the routine `log_filter_set` as function with generic parameters itemizing the types for which logging is enabled.  To only show output only for specific routines, use the `show_selected` procedure as shown in the example below. You can disable logging for any particular routine by prefixing the name with a hyphen. The `log_filter_set` routine for class [http://www.eiffel-loop.com/test/source/eros/apps/fourier_math_client_test_app.html](FOURIER_MATH_CLIENT_TEST_APP) illustrates:


````
feature {NONE} -- Implementation
````

````
	log_filter_set: EL_LOG_FILTER_SET [
		like Current,
		EROS_CALL_REQUEST_HANDLER_PROXY,
		FFT_COMPLEX_64_PROXY
	]
		do
			create Result.make
			Result.show_selected ({SIGNAL_MATH_PROXY}, "cosine_waveform")
		end
````
The class filter is compared only with the generating class name so all child classes in a particular inheritance tree must be listed individually.

**Command Options**

A list of command options which effect the logging system can be found in class [http://www.eiffel-loop.com/library/runtime/logging/support/el_log_command_options.html](EL_LOG_COMMAND_OPTIONS).

**User step-through logging**

For debugging purposes you may wish to pause execution on the exit of each logged routine. The following call causes the application to stop execution on the exit of every logged routine and prompts the user to press enter to continue:


````
Logging.set_prompt_user_on_exit (true)
````
The logging object is available in the root class or by inheriting [http://www.eiffel-loop.com/library/runtime/logging/el_module_logging.html](EL_MODULE_LOGGING).

**Logging threads**

Logging a separate thread just requires that you inherit from [http://www.eiffel-loop.com/library/runtime/logging/concurrency/thread/el_logged_identified_thread.html](EL_LOGGED_IDENTIFIED_THREAD) and make sure the routine `on_start` gets called. It will anyway unless you do something to over-ride this routine.


````
feature {NONE} -- Event handling
````

````
	on_start
		do
			Log_manager.add_thread (Current)
		end
````
By default it is the log output of the main thread that is visible in the console terminal. To change the logging output visible in the console to another thread call redirect_thread_to_console with the thread's index. The index of the main launch thread is 1. Subsequently added threads have indexes of 2, 3, 4 etc. Use function is_valid_console_index to check if the index is valid.


````
Log_manager.redirect_thread_to_console (index)
````
It is this index which is displayed as part of the log output prompt. If you are not sure what the index of the thread is you can obtain it from the thread name with a call like:


````
my_thread_index := Log_manager.thread_index ("My thread")
````
**Synchronization Monitor**

A generic synchronization monitor allows synchronization on an object to be protected with a contract requiring that the object is locked before being referenced. It is integrated with the logging framework to help detect deadlock conditions. If a thread needs to wait for a lock on a synchronized object, both the waiting and acquiring of the lock is logged in the thread's log. See class [http://www.eiffel-loop.com/library/runtime/logging/concurrency/el_logged_mutex_reference.html](EL_LOGGED_MUTEX_REFERENCE)

**Logging Routines**

Access to the logging routines is through feature log of class [http://www.eiffel-loop.com/library/runtime/logging/el_module_log.html](EL_MODULE_LOG). The log object conforms to type [http://www.eiffel-loop.com/library/base/runtime/io/logging/el_loggable.html](EL_LOGGABLE) which has numerous procedures for writing to the log as well as some useful functions.

The procedure form: 


````
put_<lowercase type name>
````
is use to output the following types: ${STRING_8, INTEGER_32, CHARACTER_8, REAL_32 and REAL_64'.

The procedure form:


````
put_<lowercase type name>_field
````
is used to output the following types prefixed with a field label: `STRING, INTEGER, INTEGER_INTERVAL, REAL and DOUBLE`.

The procedure `put_string_field_to_max_length` is used to output a multi-line block of text in abbreviated form. The beginning and last 30 characters of the string is output up to a maximum number of characters (or 1/3 of the maximum length, whichever is smaller). If the text contains more than one line, tab indents are inserted to left align the text to the correct logging indent. The boolean function `current_routine_is_active` can be tested in order to conditionally execute a block of code if the current routine is unfiltered by any routine filter.

**Always on logging**

Class [http://www.eiffel-loop.com/library/runtime/logging/el_module_log.html](EL_MODULE_LOG) also has a special logging object named `lio`, short for "log or io". This is used in the same way as the usual log object with the difference that the output will still be written to the console even if logging is globally disabled. It can be used to write to the console instead of the usual io medium from class `ANY`.

**Log files**

All log files are put in a sub directory logs of the current working directory. If you are making your application loggable using [Unknown-path](EL_SUB_APPLICATION) then these log files are automatically deleted when the application exits. If you want a chance to inspect the log files in an editor before they disappear there are a number of ways to do this:

Use the command line switch `-keep_logs`. The log files will not be deleted and will not be overwritten during subsequent application runs. It is recommended to delete them manually.

If you are using the Eiffel Loop multi application mode framework then the log files are placed in the following subdirectory of the user home directory derived from the executable name and sub application name.


````
/<user>/home/.<executable name>/<sub app name>/logs	
````
For example if the executable is named foo and the sub application is bar then for user joeblogs the log directory path is:


````
/joeblogs/home/.foo/bar/logs
````
**Commenting out log lines**

Allthough having logging turned off is usually sufficient to maximize performance of the application it may sometimes be desirable to comment out all the logging lines. An autoedit utility application is included for that purpose in the toolkit project. The best strategy is to comment out logging calls by hand in performance critical sections.

**Future enhancements**

At present changes to the log filtering necessitates a recompilation of the code. A useful enhancement being considered will allow the default log filtering to be overridden by a Pyxis logging configuration file.


## OS Command Wrapping
Classes for creating cross platform wrappers of OS commands with about 30 "out of the box" commands provided.

**General Features**


* Command templates are based on the powerful [Evolicity text substitution library](http://www.eiffel-loop.com/library/evolicity.html).


* Support for command output capture, and error output capture.


* Automatic escaping of path arguments conforming to [http://www.eiffel-loop.com/library/base/runtime/file/naming/el_path.html](EL_PATH), namely [http://www.eiffel-loop.com/library/base/runtime/file/naming/el_file_path.html](EL_FILE_PATH) and [http://www.eiffel-loop.com/library/base/runtime/file/naming/el_dir_path.html](EL_DIR_PATH). All Windows paths are automatically put in quotes. Unix paths are automatically escaped with \ for reserved characters. This has some advantages over putting them in quotes.


* Designed for cross platform use, with special features for post-capture processing of output lines so they are consistent across platforms. See classes [http://www.eiffel-loop.com/library/runtime/process/commands/system/file/find/el_find_directories_command_i.html](EL_FIND_DIRECTORIES_COMMAND_I) and [http://www.eiffel-loop.com/library/runtime/process/commands/system/file/find/el_find_files_command_i.html](EL_FIND_FILES_COMMAND_I) as an example. Here the Unix `find` command and the Windows `dir` command are made to appear exactly the same for specific tasks.


* Support for making "convenience wrappers" without any need to create a new class. These are classes: [http://www.eiffel-loop.com/library/runtime/process/commands/kernel/el_os_command.html](EL_OS_COMMAND) and [http://www.eiffel-loop.com/library/runtime/process/commands/kernel/el_captured_os_command.html](EL_CAPTURED_OS_COMMAND).


* Has factory class [Unknown-path](EL_OS_ROUTINES_IMP) (accessible via [http://www.eiffel-loop.com/library/runtime/process/commands/system/el_module_os.html](EL_MODULE_OS)) which contains factory functions for common OS system commands.

**Information Commands**

These are "out of the box" command for obtaining system information.


* Unix command to parse output of nm-tool to get MAC address of ethernet devices


* Unix command to obtain CPU name

## Development Testing
* Regression tests based on CRC checksum comparisons of logging output and output files. These are used extensively in Eiffel-Loop projects.
* Helper classes for unit tests based on `EQA_TEST_SET`

## Internationalization
An internationalization library with support for translations rendered in Pyxis format. There are a number of tools in `el_toolkit` to support the use of this library.
## Encryption and Hashing
**AES Encryption**

An easy interface to basic AES encryption with extensions to Colin LeMahieu's [AES encryption library](https://github.com/EiffelSoftware/EiffelStudio/tree/master/Src/contrib/library/text/encryption/eel). Includes a class for reading and writing encrypted files using [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) cipher [block chains](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation).

**Hashing**

Routines for creating SHA-256 and MD5 hashes as well as UUID system time hashes.

**XML Persistence**

Library `xml-scan.ecf` provides 2 classes for storing credentials


1. [http://www.eiffel-loop.com/library/persistency/xml/doc-scan/buildable/el_buildable_aes_credential.html](EL_BUILDABLE_AES_CREDENTIAL)
2. [http://www.eiffel-loop.com/library/persistency/xml/doc-scan/buildable/el_secure_key_file.html](EL_SECURE_KEY_FILE)

## RSA Public-key Encryption
Extends Colin LeMahieu's arbitrary precision integer library to conform to some RSA standards. The most important is the ability to read key-pairs conforming to the [X509 PKCS1 standard](https://en.wikipedia.org/wiki/X.509#Sample_X.509_certificates). The top level class to access these facilities is [Unknown-path](EL_MODULE_X509_COMMAND).

The private key reader however uses a non-standard encryption scheme. It assumes the file is en	crypted using the Eiffel-Loop utility contained in `el_toolkit`.
## Evolicity Text Substitution Engine
*Evolicity* is a text substitution language that was inspired by the [Velocity text substitution language](http://velocity.apache.org/) for Java. *Evolicity* provides a way to merge the data from Eiffel objects into a text template. The template can be either supplied externally or hard-coded into an Eiffel class. The language includes, substitution variables, conditional statements and loops. Substitution variables have a BASH like syntax. Conditionals and loops have an Eiffel like syntax.

The text of this web site was generated by the Eiffel-view repository publisher (See class [Unknown-path](REPOSITORY_PUBLISHER_APP)) using the following combination of *Evolicity* templates:


1. [doc-config/main-template.html.evol](https://github.com/finnianr/Eiffel-Loop/blob/master/doc-config/main-template.html.evol)
2. [doc-config/site-map-content.html.evol](https://github.com/finnianr/Eiffel-Loop/blob/master/doc-config/site-map-content.html.evol)
3. [doc-config/directory-tree-content.html.evol](https://github.com/finnianr/Eiffel-Loop/blob/master/doc-config/directory-tree-content.html.evol)
4. [doc-config/eiffel-source-code.html.evol](https://github.com/finnianr/Eiffel-Loop/blob/master/doc-config/eiffel-source-code.html.evol)

To make an Eiffel class serializable with *Evolicity* you inherit from class [http://www.eiffel-loop.com/library/text/template/evolicity/serialization/evolicity_serializeable.html](EVOLICITY_SERIALIZEABLE). Read the class notes for details on how to use. You can also access the substitution engine directly from the shared instance in class [http://www.eiffel-loop.com/library/text/template/evolicity/evolicity_shared_templates.html](EVOLICITY_SHARED_TEMPLATES)

**Features**


* Templates are compiled to an intermediate byte code stored in `.evc` files. This saves time consuming lexing operations on large templates.
* Has a class [http://www.eiffel-loop.com/library/text/template/evolicity/serialization/evolicity_cacheable_serializeable.html](EVOLICITY_CACHEABLE_SERIALIZEABLE) for caching the substituted output. Useful for generating pages on a web-server.

**Syntax Documentation**

See class [http://www.eiffel-loop.com/library/text/template/evolicity/evolicity_shared_templates.html](EVOLICITY_SHARED_TEMPLATES)


## Search Engine
Classes for parsing search terms and searching a list conforming to `CHAIN [EL_WORD_SEARCHABLE]` using case-insensitive word tokenization.


* Facility to create custom search types.
* Terms can be combined using basic boolean operators.

See [myching.software](http://myching.software/en/home/my-ching.html) for an example of a commercial application that makes use of this library.
## Textual Data Formats
Classes for handling various human-readable text formats. Supported formats are: XML, XHTML, HTML, JSON, CSV. (Note: Eiffel-Loop has other libraries for parsing XML)
## Text Parsing
Classes for parsing text data.
## Text Pattern-matching
Classes for finding and matching textual patterns.
## Application License Management
A few basic classes for constructing an application license manager. The most important is a way to obtain a unique machine ID using a combination of the CPU model name and MAC address either from the network card or wifi card.

The principle developer of Eiffel-loop has developed a sophisticated license management system using RSA public key cryptography, however it is not available as open source. If you are interested to license this system for your company, please contact the developer. It has been used for the [My Ching](http://myching.software) software product.
## ZLib Compression
An Eiffel interface to the [zlib C library](https://www.zlib.net/). The main class is [http://www.eiffel-loop.com/library/utility/compression/el_compressed_archive_file.html](EL_COMPRESSED_ARCHIVE_FILE) with a few helper classes.
## Currency Exchange
Currency Exchange based on European Central bank Rates from [eurofxref-daily.xml](https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml)
## Windows Installer
**Status:** No longer maintained.

Classes to create a Windows install program.

This library has been superceded by the capabilities of the [Multi-Application Management](http://www.eiffel-loop.com/library/app-manage.html) library.
## Eiffel Development Utilities
A "Swiss-army knife" of Eiffel development utilities invokeable by a command-line switch.

**Sub-applications**

[http://www.eiffel-loop.com/tool/eiffel/source/analyse/apps/class_descendants_app.html](CLASS_DESCENDANTS_APP) outputs class descendants for selected class as a text file and is designed to be used as an external tool from within EiffelStudio.

Command switch: `-class_descendants`

[http://www.eiffel-loop.com/tool/eiffel/source/root/apps/eiffel_view_app.html](EIFFEL_VIEW_APP) publishes source code and descriptions of Eiffel projects to a website as static html and generate a `Contents.md` file in Github markdown. See [eiffel.org article](https://www.eiffel.org/blog/Finnian%20Reilly/2018/10/eiffel-view-repository-publisher-version-1-0-18)

Command switch: `-eiffel_view`

[http://www.eiffel-loop.com/tool/eiffel/source/root/apps/generate/zcodec_generator_app.html](ZCODEC_GENERATOR_APP) generates Eiffel classes conforming to [http://www.eiffel-loop.com/library/base/text/zstring/codec/el_zcodec.html](EL_ZCODEC) from VTD-XML C code

Command switch: `-generate_codecs`

[http://www.eiffel-loop.com/tool/eiffel/source/root/apps/ecf_to_pecf_app.html](ECF_TO_PECF_APP) converts Eiffel configuration files to Pyxis format

Command switch: `-ecf_to_pecf`

[http://www.eiffel-loop.com/tool/eiffel/source/root/apps/generate/library_override_app.html](LIBRARY_OVERRIDE_APP) generates override of standard libaries to work with Eiffel-Loop

Command switch: `-library_override`: 

[http://www.eiffel-loop.com/tool/eiffel/source/analyse/apps/repository_note_link_checker_app.html](REPOSITORY_NOTE_LINK_CHECKER_APP) expands `$source` variable path in wiki-links contained in a wiki-markup text file. The app use a [http://www.eiffel-loop.com/tool/eiffel/source/root/apps/eiffel_view_app.html](EIFFEL_VIEW_APP) publishing configuration. Write the expanded output to file named as follows:


````
<file name>.expanded.<file extension>
````
An incidental function is to expand all tabs in the markup as 3 spaces.

Command switch: `-expand_links`

[http://www.eiffel-loop.com/tool/eiffel/source/edit/apps/source_file_name_normalizer_app.html](SOURCE_FILE_NAME_NORMALIZER_APP) normalize class filenames as lowercase classnames within a source directory

Command switch: `-normalize_class_file_name` 

[http://www.eiffel-loop.com/tool/eiffel/source/root/apps/imp_class_location_normalizer_app.html](IMP_CLASS_LOCATION_NORMALIZER_APP) normalizes location of implementation classes in relation to respective interfaces for all projects listed in publisher configuration.

Command switch: `normalize_imp_location`

[http://www.eiffel-loop.com/tool/eiffel/source/root/apps/winzip_software_package_builder_app.html](WINZIP_SOFTWARE_PACKAGE_BUILDER_APP) builds a signed self-extracting software installer for Windows OS using signtool and WinZip tools.

Command switch: `-winzip_exe_builder`

**Download**

Download binary of [`el_eiffel`](https://github.com/finnianr/Eiffel-Loop/releases/latest) for *Ubuntu 14.04* or *Linux Mint 17.x*.
## Eiffel Class Editing Utilities
A "Swiss-army knife" of Eiffel class editing utilities invokeable by a command-line switch.

**Sub-applications**

[Unknown-path](CLASS_PREFIX_REMOVAL_APP) removes all classname prefixes over a source directory

Command switch: `-remove_prefix`

[http://www.eiffel-loop.com/tool/eiffel/source/edit/apps/note_editor_app.html](NOTE_EDITOR_APP) add default values to note fields using a source tree manifest.

Command switch: `-edit_notes`

[http://www.eiffel-loop.com/tool/eiffel/source/edit/apps/feature_editor_app.html](FEATURE_EDITOR_APP) expands Eiffel shorthand code in source file and reorders feature blocks alphabetically.

Command switch: `-feature_edit`

[http://www.eiffel-loop.com/tool/eiffel/source/edit/apps/find_and_replace_app.html](FIND_AND_REPLACE_APP) finds and replaces text in Eiffel source files specified by a source tree manifest Command switch: `-find_replace`

[http://www.eiffel-loop.com/tool/eiffel/source/edit/apps/source_log_line_remover_app.html](SOURCE_LOG_LINE_REMOVER_APP) comments out logging lines from Eiffel source code tree

Command switch: `-elog_remover`

[Unknown-path](SOURCE_TREE_CLASS_RENAME_APP) renames classes defined by a source manifest file

Command switch: `-class_rename`

**Download**

Download binary of [`el_eiffel`](https://github.com/finnianr/Eiffel-Loop/releases/latest) for *Ubuntu 14.04* or *Linux Mint 17.x*.
## Eiffel Class Analysis Utilities
A "Swiss-army knife" of Eiffel class analysis utilities invokeable by a command-line switch.

**Sub-applications**

[http://www.eiffel-loop.com/tool/eiffel/source/analyse/apps/check_locale_strings_app.html](CHECK_LOCALE_STRINGS_APP) verifies localization translation identifiers against various kinds of source texts.

Command switch: `-check_locale_strings`

[http://www.eiffel-loop.com/tool/eiffel/source/analyse/apps/class_descendants_app.html](CLASS_DESCENDANTS_APP) outputs a list of descendants for a class as an Eiffel note field that can be copy/pasted into Eiffel source code.

Command switch: `-descendants`

[Unknown-path](CODEBASE_STATISTICS_APP) counts classes, code words and combined source file size for Eiffel source trees specified in manifest

Command switch: `-codebase_stats`

[http://www.eiffel-loop.com/tool/eiffel/source/analyse/apps/encoding_check_app.html](ENCODING_CHECK_APP) checks for UTF-8 files that could be encoded as Latin-1

Command switch: `-check_encoding`

[http://www.eiffel-loop.com/tool/eiffel/source/analyse/apps/repository_note_link_checker_app.html](REPOSITORY_NOTE_LINK_CHECKER_APP) checks for invalid class references in repository note links

Command switch: `-check_note_links`

[http://www.eiffel-loop.com/tool/eiffel/source/analyse/apps/undefine_pattern_counter_app.html](UNDEFINE_PATTERN_COUNTER_APP) counts the number of classes in the source tree manifest that exhibit multiple inheritance of classes with an identical pattern of feature undefining.

Command switch: `-undefine_counter`

**Download**

Download binary of [`el_eiffel`](https://github.com/finnianr/Eiffel-Loop/releases/latest) for *Ubuntu 14.04* or *Linux Mint 17.x*.
## Eiffel Utility Tests
Test sets for Eiffel utitlities
## Utilities Toolkit
A "Swiss-army knife" of command line utilities accessible via a command line option.

The most useful ones are listed below with the option name:

[http://www.eiffel-loop.com/tool/toolkit/source/apps/html/html_body_word_counter_app.html](HTML_BODY_WORD_COUNTER_APP) counts the number of words in a HTML document.

Command switch: `-body_word_counts`

[http://www.eiffel-loop.com/tool/toolkit/source/apps/crypto_command_shell_app.html](CRYPTO_COMMAND_SHELL_APP) is a menu driven shell of useful cryptographic operations.

Command switch: `-crypto`

[http://www.eiffel-loop.com/tool/toolkit/source/apps/thunderbird_book_exporter_app.html](THUNDERBIRD_BOOK_EXPORTER_APP) merges a localized folder of emails in the Thunderbird email client into a single HTML book with chapter numbers and titles derived from subject line. The output files are used to generate a Kindle book.

Command switch: `-export_book`

[http://www.eiffel-loop.com/tool/toolkit/source/apps/html/thunderbird_www_exporter_app.html](THUNDERBIRD_WWW_EXPORTER_APP) exports emails from selected Thunderbird email folders as HTML bodies (extension: `body`). As the name implies, only the body of the HTML is preserved. A matching folder structure is also created. This is useful for HTML content managers.

Command switch: `-export_www`

[http://www.eiffel-loop.com/tool/eiffel/source/root/apps/pyxis_translation_tree_compiler_app.html](PYXIS_TRANSLATION_TREE_COMPILER_APP) compiles tree of Pyxis translation files into multiple locale files named `locale.x` where `x` is a 2 letter country code. Does nothing if source files are all older than locale files. See class [Unknown-path](EL_LOCALE_I).

Command switch: `-compile_translations`

[http://www.eiffel-loop.com/tool/toolkit/source/apps/pyxis/pyxis_to_xml_app.html](PYXIS_TO_XML_APP) converts Pyxis format to XML with special support for Eiffel configuration files in Pyxis format (extension `pecf`). The attribute `configuration_ns` can be used as convenient shorthand for the ECF schema configuration information.

Command switch: `-pyxis_to_xml`

[http://www.eiffel-loop.com/tool/toolkit/source/apps/youtube_video_downloader_app.html](YOUTUBE_VIDEO_DOWNLOADER_APP) downloads and merges selected audio and video streams from a Youtube video.

Command switch: `-youtube_dl`

[http://www.eiffel-loop.com/tool/toolkit/source/apps/file_manifest_app.html](FILE_MANIFEST_APP) creates an XML file manifest of a target directory using either the default Evolicity template or an optional external Evolicity template. See class [http://www.eiffel-loop.com/library/text/template/evolicity/serialization/evolicity_serializeable.html](EVOLICITY_SERIALIZEABLE)

Command switch: `-file_manifest`

[http://www.eiffel-loop.com/tool/toolkit/source/apps/undated_photo_finder_app.html](UNDATED_PHOTO_FINDER_APP) lists JPEG photos that lack the EXIF field `Exif.Photo.DateTimeOriginal`.

Command switch: `-undated_photos`

[http://www.eiffel-loop.com/tool/toolkit/source/apps/backup/duplicity_backup_app.html](DUPLICITY_BACKUP_APP) creates incremental duplicity backups using a configuration file in Pyxis format.

Command switch: `-duplicity`

[http://www.eiffel-loop.com/tool/toolkit/source/apps/backup/duplicity_restore_app.html](DUPLICITY_RESTORE_APP) restores either an entire duplicity backup or a selected file or directory.  Restoration output directory is defined in same configuration file as backup.

Command switch: `-duplicity_restore`

**Download**

Download binary of [`el_toolkit`](https://github.com/finnianr/Eiffel-Loop/releases/latest) for *Ubuntu 14.04* or *Linux Mint 17.x*.
## Eiffel-Loop Performance Benchmarks

## ID3-tags.ecf
See class [$source ID3_TAGS_AUTOTEST_APP]

Due to C name space clashes with `TagLib.ecf` these tests have been separated from `test.ecf`
## amazon-instant-access.ecf
Tests for Eiffel interface to Amazon Instant Access API. See class [Unknown-path](AMAZON_INSTANT_ACCESS_TEST_APP)
## base.ecf (Eiffel-Loop)
Test Eiffel-Loop base classes. See [http://www.eiffel-loop.com/test/source/base/base_autotest_app.html](BASE_AUTOTEST_APP)
## C-language-interface.ecf
See class [http://www.eiffel-loop.com/test/source/C-language-interface/c_language_interface_autotest_app.html](C_LANGUAGE_INTERFACE_AUTOTEST_APP)
## Common Classes
**Project List**

Eiffel coding experiments and classes containing test data that are used in the following projects:


````
benchmark/benchmark.ecf
test/test.ecf
test/eiffel2java/eiffel2java.ecf
tool/toolkit/toolkit.ecf
tool/eiffel/eiffel.ecf
````

## compression.ecf
See class [Unknown-path](COMPRESSION_TEST_APP)
## currency.ecf
See class [Unknown-path](CURRENCY_TEST_APP)
## Eco-DB.ecf
Test [Eco-DB (Eiffel CHAIN Orientated Database)](http://www.eiffel-loop.com/library/Eco-DB.html) library.

Test application: [http://www.eiffel-loop.com/test/source/Eco-DB/eco_db_autotest_app.html](ECO_DB_AUTOTEST_APP)
## Eiffel Core Concepts
Test core concepts and behaviour of basic Eiffel code and libraries. See class [http://www.eiffel-loop.com/test/source/eiffel/eiffel_autotest_app.html](EIFFEL_AUTOTEST_APP)
## encryption.ecf
See class [http://www.eiffel-loop.com/test/source/encryption/app/encryption_autotest_app.html](ENCRYPTION_AUTOTEST_APP)
## eros.ecf
Test [Eiffel Remote Object Server (EROS)](http://www.eiffel-loop.com/library/eros.html) protocol library.

**Test Apps**


* [http://www.eiffel-loop.com/test/source/eros/apps/eros_autotest_app.html](EROS_AUTOTEST_APP)
* [http://www.eiffel-loop.com/test/source/eros/apps/bext_client_test_app.html](BEXT_CLIENT_TEST_APP)
* [http://www.eiffel-loop.com/test/source/eros/apps/bext_server_test_app.html](BEXT_SERVER_TEST_APP)
* [http://www.eiffel-loop.com/test/source/eros/apps/fourier_math_client_test_app.html](FOURIER_MATH_CLIENT_TEST_APP)
* [http://www.eiffel-loop.com/test/source/eros/apps/fourier_math_server_test_app.html](FOURIER_MATH_SERVER_TEST_APP)

## evolicity.ecf
Test of Evolicity text substitution engine. See class [Unknown-path](EVOLICITY_TEST_APP)
## file-processing.ecf
Test [File and Directory Processing)](http://www.eiffel-loop.com/library/file-processing.html) library.

See class [http://www.eiffel-loop.com/test/source/file-processing/file_processing_autotest_app.html](FILE_PROCESSING_AUTOTEST_APP)
## http-client.ecf
See class [http://www.eiffel-loop.com/test/source/http-client/http_client_autotest_app.html](HTTP_CLIENT_AUTOTEST_APP)
## i18n.ecf
Test localization library. See class [http://www.eiffel-loop.com/test/source/i18n/i18n_autotest_app.html](I18N_AUTOTEST_APP)
## image-utils.ecf
See class [Unknown-path](SVG_TO_PNG_CONVERSION_TEST_APP)
## markup-docs.ecf
* Test subject line decoding for Thunderbird Email Export with [Unknown-path](THUNDERBIRD_TEST_APP)
* Regression test reading of Open Office Spreadsheet with [Unknown-path](OPEN_OFFICE_TEST_APP)

## multimedia.ecf
* Test wav to mp3 conversion

## network.ecf
Test network library classes


* [Unknown-path](TEST_SIMPLE_CLIENT)
* [Unknown-path](SIMPLE_SERVER_TEST_APP)

## os-command.ecf
* Test OS command interface library. See class [http://www.eiffel-loop.com/test/source/os-command/os_command_autotest_app.html](OS_COMMAND_AUTOTEST_APP)
* Test set for classes that manage and read file system content. See class [http://www.eiffel-loop.com/test/source/os-command/test-set/file_and_directory_test_set.html](FILE_AND_DIRECTORY_TEST_SET)

## paypal-SBM.ecf
Tests for Eiffel interface to PayPal Payments Standard Button Manager API. See class [Unknown-path](PAYPAL_STANDARD_BUTTON_MANAGER_TEST_APP)
## public-key-encryption.ecf
Tests for RSA public key encryption tools. See class [Unknown-path](PUBLIC_KEY_ENCRYPTION_TEST_APP)
## pyxis-scan.ecf
Test application class: [http://www.eiffel-loop.com/test/source/pyxis-scan/pyxis_scan_autotest_app.html](PYXIS_SCAN_AUTOTEST_APP)
## Root class and Experiments
Root class [APPLICATION_ROOT](http://www.eiffel-loop.com/test/source/root/application_root.html) and a collection of developer experiments to verify understanding of ISE base classes.

**Autotest Sub-applications**


````
EL_AUTOTEST_APPLICATION* [EQA_TYPES -> TUPLE create default_create end]
	${MULTIMEDIA_AUTOTEST_APP}
	${EL_CRC_32_AUTOTEST_APPLICATION}* [EQA_TYPES -> ${TUPLE} create default_create end]
		${TAGLIB_AUTOTEST_APP}
		${NETWORK_AUTOTEST_APP}
		${ECO_DB_AUTOTEST_APP}
		${EVOLICITY_AUTOTEST_APP}
		${I18N_AUTOTEST_APP}
		${IMAGE_UTILS_AUTOTEST_APP}
		${OPEN_OFFICE_AUTOTEST_APP}
		${THUNDERBIRD_AUTOTEST_APP}
		${PYXIS_SCAN_AUTOTEST_APP}
		${TEXT_FORMATS_AUTOTEST_APP}
		${VTD_XML_AUTOTEST_APP}
		${XML_SCAN_AUTOTEST_APP}
	${AMAZON_INSTANT_ACCESS_AUTOTEST_APP}
	${BASE_AUTOTEST_APP}
	${C_LANGUAGE_INTERFACE_AUTOTEST_APP}
	${COMPRESSION_AUTOTEST_APP}
	${CURRENCY_AUTOTEST_APP}
	${EIFFEL_AUTOTEST_APP}
	${ENCRYPTION_AUTOTEST_APP}
	${FILE_PROCESSING_AUTOTEST_APP}
	${OS_COMMAND_AUTOTEST_APP}
	${PAYPAL_STANDARD_BUTTON_MANAGER_AUTOTEST_APP}
	${PUBLIC_KEY_ENCRYPTION_AUTOTEST_APP}
	${SEARCH_ENGINE_AUTOTEST_APP}
	${TEXT_PROCESS_AUTOTEST_APP}
	${EROS_AUTOTEST_APP}
	${HTTP_CLIENT_AUTOTEST_APP}
````
**General Test Sub-applications**


````
EL_APPLICATION*
	${EL_STANDARD_REMOVE_DATA_APP}
	${EL_LOGGED_APPLICATION}*
		${BEXT_CLIENT_TEST_APP}
		${FOURIER_MATH_CLIENT_TEST_APP}
		${EL_LOGGED_COMMAND_LINE_APPLICATION}* [C -> ${EL_APPLICATION_COMMAND}]
			${EROS_SERVER_APPLICATION}* [C -> ${EROS_SERVER_COMMAND} create make end]
				${BEXT_SERVER_TEST_APP}
				${FOURIER_MATH_SERVER_TEST_APP}
	${EL_BATCH_AUTOTEST_APP}
		${AUTOTEST_APP}
	${EL_VERSION_APP}
	${EL_STANDARD_UNINSTALL_APP}
	${EL_COMMAND_LINE_APPLICATION}* [C -> ${EL_APPLICATION_COMMAND}]
		${EL_LOGGED_COMMAND_LINE_APPLICATION}* [C -> ${EL_APPLICATION_COMMAND}]
````
**Test Sets**


````
EL_EQA_TEST_SET*
	${EL_FILE_DATA_TEST_SET}*
		${AUDIO_COMMAND_TEST_SET}
		${EL_COPIED_FILE_DATA_TEST_SET}*
			${TAGLIB_TEST_SET}
			${FTP_TEST_SET}
			${SIMPLE_CLIENT_SERVER_TEST_SET}
			${FILE_LOCKING_TEST_SET}
			${PYXIS_TO_XML_TEST_SET}
			${RSA_PUBLIC_KEY_ENCRYPTION_TEST_SET}
			${EIFFEL_PARSING_TEST_SET}
			${JOBSERVE_SEARCHER_TEST_SET}
			${XML_TO_PYXIS_CONVERTER_TEST_SET}
		${AMAZON_INSTANT_ACCESS_TEST_SET}
		${DATA_DIGESTS_TEST_SET}
		${GENERAL_TEST_SET}
		${COM_OBJECT_TEST_SET}
		${ECD_READER_WRITER_TEST_SET}
		${SEARCH_ENGINE_TEST_SET}
			${ENCRYPTED_SEARCH_ENGINE_TEST_SET}
		${OBJECT_BUILDER_TEST_SET}
		${REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_SET}
		${HTTP_CONNECTION_TEST_SET}
		${EL_COPIED_DIRECTORY_DATA_TEST_SET}*
			${COMPRESSION_TEST_SET}
			${ENCRYPTION_TEST_SET}
			${EVOLICITY_TEST_SET}
			${OS_COMMAND_TEST_SET}
			${COPIED_SVG_DIRECTORY_DATA_TEST_SET}*
				${IMAGE_UTILS_TEST_SET}
			${THUNDERBIRD_EQA_TEST_SET}*
				${THUNDERBIRD_EXPORT_TEST_SET}
		${EL_GENERATED_FILE_DATA_TEST_SET}*
			${HELP_PAGES_TEST_SET}*
				${FILE_TREE_INPUT_OUTPUT_COMMAND_TEST_SET}
				${FILE_SYNC_MANAGER_TEST_SET}
				${FILE_AND_DIRECTORY_TEST_SET}
	${ZSTRING_TEST_SET}
	${NETWORK_TEST_SET}
	${ARRAYED_LIST_TEST_SET}
	${CHARACTER_TEST_SET}
	${CONTAINER_STRUCTURE_TEST_SET}
		${WIDGET_TEST_SET}
	${DATE_TIME_TEST_SET}
	${EIFFEL_NAME_TRANSLATEABLE_TEST_SET}
	${BASE_POWER_2_CONVERTER_TEST_SET}
	${REFLECTION_TEST_SET}
	${SE_ARRAY2_TEST_SET}
	${SPLIT_STRING_TEST_SET}
	${STRING_CONVERSION_TEST_SET}
	${STRING_ITERATION_CURSOR_TEST_SET}
	${STRING_TEST_SET}
	${SUBSTRING_32_ARRAY_TEST_SET}
	${TEMPLATE_TEST_SET}
	${URI_TEST_SET}
	${UTF_CONVERTER_TEST_SET}
	${ZSTRING_EDITOR_TEST_SET}
	${ZSTRING_TOKEN_TABLE_TEST_SET}
	${CURRENCY_TEST_SET}
	${AGENT_TEST_SET}
	${DATE_TIME_2_TEST_SET}
	${EIFFEL_TEST_SET}
	${FILE_TEST_SET}
	${NUMERIC_TEST_SET}
	${STRUCTURE_TEST_SET}
	${TEXT_DATA_TEST_SET}
	${TUPLE_TEST_SET}
	${TYPE_TEST_SET}
	${UUID_TEST_SET}
	${DIGEST_ROUTINES_TEST_SET}
	${PAYPAL_TEST_SET}
	${COMMA_SEPARATED_IMPORT_TEST_SET}
	${DOC_TYPE_TEST_SET}
	${JSON_PARSING_TEST_SET}
	${PATTERN_MATCH_TEST_SET}
		${STRING_32_PATTERN_MATCH_TEST_SET}
		${ZSTRING_PATTERN_MATCH_TEST_SET}
	${STRING_EDITION_HISTORY_TEST_SET}
	${EROS_TEST_SET}
	${EL_DIRECTORY_CONTEXT_TEST_SET}*
		${XML_TEST_SET}
		${VTD_XML_TEST_SET}
		${EIFFEL_LOOP_TEST_SET}*
			${I18N_LOCALIZATION_TEST_SET}
			${OPEN_OFFICE_TEST_SET}
			${CREATEABLE_FROM_XPATH_MATCH_EVENTS_TEST_SET}
			${DOCUMENT_NODE_STRING_TEST_SET}
			${PATH_TEST_SET}
	${EL_TEST_DATA_TEST_SET}*
	${EL_DEFAULT_TEST_SET}
	${BIT_ROUTINE_TEST_SET}
	${HASH_TABLE_TEST_SET}
	${MARKUP_ESCAPE_TEST_SET}
## search-engine.ecf
See class ${SEARCH_ENGINE_AUTOTEST_APP}
## TagLib.ecf
See class ${TAGLIB_AUTOTEST_APP}
## text-formats.ecf
See class ${TEXT_FORMATS_AUTOTEST_APP}
## text-process.ecf
See class ${TEXT_PROCESS_AUTOTEST_APP}
## vtd-xml.ecf
Tests for Eiffel interface VTD-XML C API

See class ${VTD_XML_AUTOTEST_APP}
## wel-x-audio.ecf
Maintenance of Windows audio classes See class ${MEDIA_PLAYER_DUMMY_APP}
## xml-scan.ecf
Test application class: ${XML_SCAN_AUTOTEST_APP}
## eiffel2java.ecf (Eiffel-Loop)
Test sets for the [./library/eiffel2java.html Eiffel-Loop Java interface library]. This library provides a useful layer of abstraction over the Eiffel Software JNI interface.
