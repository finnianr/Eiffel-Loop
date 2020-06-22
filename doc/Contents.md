# Eiffel-Loop Contents
## Signal Math Demo of the EROS Protocol
A multi-mode application demonstrating the [EROS remote object protocol](http://www.eiffel-loop.com/library/eros.html). The application calculates Fourier transformations based on Greg Lee's [Numeric Eiffel Library](https://teameiffel.blogspot.com/2006/04/greg-lees-numeric-eiffel-library.html). It has two client modes and two server modes, accessible via a command line option.

**Client Modes**

`-test_client` Sub-application [FFT_MATH_CLIENT_TEST_APP](http://www.eiffel-loop.com/example/net/EROS/signal-math/source/apps/fft_math_client_test_app.html)

Test client to generate random wave forms and do fourier transforms for 25 seconds

`-bext_test_client` Sub-application [BEXT_CLIENT_TEST_APP](http://www.eiffel-loop.com/test/source/eros/apps/bext_client_test_app.html)

Client to test Binary Encoded XML Transfer (BEXT).

**Server Modes**

`-bext_test_server` Sub-application [BEXT_CLIENT_TEST_APP](http://www.eiffel-loop.com/test/source/eros/apps/bext_client_test_app.html)

Server to test Binary Encoded XML Transfer (BEXT). Ctrl-c shuts down the server.

`-test_server` Sub-application [FFT_MATH_SERVER_TEST_APP](http://www.eiffel-loop.com/example/net/EROS/signal-math/source/apps/fft_math_server_test_app.html)

Single connection test server for fourier math. Ctrl-c shuts down the server.

**Installer Mode**

`-install` Sub-application [EL_STANDARD_INSTALLER_APP](http://www.eiffel-loop.com/library/runtime/app-manage/multi-app/sub-app/standard/el_standard_installer_app.html)

Installs application with desktop menu options for each mode.


## Signal Math EROS Server with GUI
A multi-threaded EROS server demonstrating the [EROS remote object protocol](http://www.eiffel-loop.com/library/eros.html). The application performs signal math including Fourier transformations based on Greg Lee's [Numeric Eiffel Library](https://teameiffel.blogspot.com/2006/04/greg-lees-numeric-eiffel-library.html)

**Features**


* A graphical user interface (GUI) to control startup and shutdown.
* GUI monitors 11 different performance characteristics.
* GUI has controls allowing you to switch the console logging output to a different thread context.

**Screenshot**

[Server GUI and terminal window displaying logging output](http://www.eiffel-loop.com/images/screenshot/console-thread-switch.png)
## Submission for 99-bottles-of-beer.net
Eiffel submission for [www.99-bottles-of-beer.net](http://www.99-bottles-of-beer.net/).

This website contains sample programs for over 1500 languages and variations, all of which print the lyrics of the song "99 Bottles of Beer".
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

For details on how to use, read the source documentation notes in class [RHYTHMBOX_MUSIC_MANAGER_APP](http://www.eiffel-loop.com/example/manage-mp3/source/apps/rhythmbox_music_manager_app.html).

**Download**

Download the latest executable for *Ubuntu 14.04* or *Linux Mint 17.x* at the bottom of [this page](https://github.com/finnianr/Eiffel-Loop/releases/latest). You also need the following command line tools to be installed: `sox, swgen, avconv, lame, gvfs-mount`.

Warning: **Use at your own risk.** It is recommended that you have a backup of your MP3 collection and rhythmbox configuration files (Usually in `$HOME/.local/share/rhythmbox`). The developer does not take any responsibility for any data loss that may occur as a result of using *el_rhythmbox*.


## Vision-2 Extensions Demo
Test application for selected components from Eiffel-Loop [extension libraries for Vision-2 and Docking](http://www.eiffel-loop.com/library/vision2-x.html).
## Eiffel to Java
Demonstration program for the [Eiffel-Loop Java interface library](http://www.eiffel-loop.com/library/eiffel2java.html). This library provides a useful layer of abstraction over the Eiffel Software JNI interface.
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


## Command-line Arguments
Classes for reading and mapping command line arguments
## Data Structure
Various hash-table, array, list, chain and linear types

**Hash Tables**


````
HASH_TABLE
	[$source EL_HASH_TABLE]
			[$source EL_PROCEDURE_TABLE]
	[$source EL_HASH_SET]
	[$source EL_FUNCTION_RESULT_TABLE]
	[$source EL_CODE_TABLE]
		[$source EL_UNIQUE_CODE_TABLE]
	[$source EL_GROUP_TABLE]
	[$source EL_TYPE_TABLE]
````
**Linear Chains**


````
[$source EL_LINEAR]*
	[$source EL_CHAIN]*
		[$source EL_ARRAYED_LIST]
			[$source EL_SUB_APPLICATION_LIST]
			[$source EL_ARRAYED_MAP_LIST]
				[$source EL_SORTABLE_ARRAYED_MAP_LIST]*
					[$source EL_VALUE_SORTABLE_ARRAYED_MAP_LIST]
					[$source EL_KEY_SORTABLE_ARRAYED_MAP_LIST]
			[$source EL_IMPORTABLE_ARRAYED_LIST]
			[$source EL_SORTABLE_ARRAYED_LIST]
			[$source EL_QUERYABLE_ARRAYED_LIST]
			[$source EL_UNIQUE_ARRAYED_LIST]
			[$source EL_CALL_SEQUENCE]
````
**Other Classes**


* Sub-array abstraction and byte array
* Repeated numeric encoding
* Tuple initialization
* Object initialization abstractions
* Software versioning




## File System
Classes for the following:


* Reading file properties
* Processing directory data

## Input/Output
Classes for the following:


* Writing to the console with color highlighting
* Read user input data

## Math
Some basic math classes for the following:


* 2D geometry
* Calculating integrals of arbitrary functions
* Representing column vectors

## Data Persistence
Classes providing the following facilities:


* Reading and writing arrays of floating-point type `DOUBLE`.
* Files that notify a listener of byte-count written and read.
* A file conforming to `PLAIN_TEXT_FILE` that implements [EL_OUTPUT_MEDIUM](http://www.eiffel-loop.com/library/base/runtime/io/medium/el_output_medium.html)
* File line source and other abstractions

## Class Reflection
Classes for setting and getting data attributes using class reflection.
## Runtime Operations
Classes for the following:


* Exception handling
* Reading and writing from memory locations
* Accessing operating environment information
* Tracking progress of time consuming operations
* Managing shared resources for competing threads

## Utility
Classes providing the following facilities:


* Benchmarking
* Date/time formatting
* Memory writing
* Cyclic redundancy check
* Command shells
* Extensions to ES uuid.ecf

## Text Processing
Classes providing the following:


* Character and character sequence conversion
* Character encoding
* File, directory and resource naming
* Deferred internationalization
* Text line processing
* Parsing and manipulating name-value pairs
* Associating formatting styles with strings
* URI encoding/decoding
* UTF encoding/decoding

## String Handling
Classes providing the following:


* Managing lists of strings
* String escaping
* Efficient string splitting
* Recording and managing string edit histories
* Abstractions for objects createable from strings
* String occurrence interval lists

## Class ZSTRING
An implementation of a memory compact string with the same unicode character range as the base class [STRING_32](https://www.eiffel.org/files/doc/static/trunk/libraries/base/string_32_chart.html) and conforming to [STRING_GENERAL](https://www.eiffel.org/files/doc/static/trunk/libraries/base/string_general_chart.html). ZSTRING is an alias for the actual class name [EL_ZSTRING](http://www.eiffel-loop.com/library/base/text/zstring/el_zstring.html). [EL_ZSTRING](http://www.eiffel-loop.com/library/base/text/zstring/el_zstring.html) has many additional routines not found in STRING_32, as for example: Python like tuple substitution.

**See Articles**


* [ZSTRING released in Eiffel-Loop 1.3.1](https://www.eiffel.org/blog/finnianr/zstring_released_in_eiffelloop_131)
* [Introducing class ZSTRING](https://www.eiffel.org/blog/finnianr/introducing_class_zstring)
* [ISO-8859 is dead, long live ISO-8859](https://www.eiffel.org/article/iso8859_is_dead_long_live_iso8859)

**Benchmarks ZSTRING vs STRING_32**


* [Base character-set Latin-1](http://www.eiffel-loop.com/benchmark/ZSTRING-benchmarks-latin-1.html)
* [Base character-set Latin-15](http://www.eiffel-loop.com/benchmark/ZSTRING-benchmarks-latin-15.html)

## Image Utilities
Image utilities providing:


1. SVG to PNG conversion using C library [librsvg](http://librsvg.sourceforge.net/)
2. Miscellaneous routines from the [Cairo graphics C library](https://cairographics.org/)

## XHTML Viewer
A basic XHTML text renderer based on the [EV_RICH_TEXT](https://www.eiffel.org/files/doc/static/17.05/libraries/vision2/ev_rich_text_flatshort.html) component found in the [EiffelVision2 library](https://www.eiffel.org/doc/solutions/EiffelVision_2).

It was used to create the help system in the [My Ching software](http://myching.software) with page content authored in the Thunderbird email client and then exported as XHTML.

See class [EL_HTML_TEXT](http://www.eiffel-loop.com/library/graphic/toolkit/html-viewer/el_html_text.html) below for supported XHTML tags. This component facilitates the creation of a hyperlinked contents side bar in a split window.
## Vision2-X UI Container Extensions
Window, dialogs and other widget-container extensions for the [EiffelVision2](https://www.eiffel.org/resources/libraries/eiffelvision2) library.

**Container Descendants**


````
EV_CONTAINER*
	EV_CELL
		EV_VIEWPORT
			EV_SCROLLABLE_AREA
				[$source EL_SCROLLABLE_AREA]
			[$source EL_CENTERED_VIEWPORT]
		EV_WINDOW
			EV_TITLED_WINDOW
				EV_DIALOG
					EV_UNTITLED_DIALOG
						[$source EL_PROGRESS_DIALOG]
						[$source EL_VERTICAL_DIALOG]*
							[$source EL_HORIZONTAL_DIALOG]*
								[$source EL_HYPERLINK_MENU]*
					EV_MESSAGE_DIALOG
						EV_CONFIRMATION_DIALOG
							[$source EL_CONFIRMATION_DIALOG]
								[$source EL_SAVE_CHANGES_CONFIRMATION_DIALOG]
								[$source EL_APPLY_CHANGES_CONFIRMATION_DIALOG]
						EV_INFORMATION_DIALOG
							[$source EL_INFORMATION_DIALOG]
						EV_WARNING_DIALOG
							[$source EL_LOCALE_WARNING_DIALOG]
						EV_ERROR_DIALOG
							[$source EL_ERROR_DIALOG]
						[$source EL_MESSAGE_DIALOG]
							[$source EL_ERROR_DIALOG]
							[$source EL_INFORMATION_DIALOG]
					[$source EL_DIALOG]*
				[$source EL_TITLED_WINDOW]
					[$source EL_TITLED_WINDOW_WITH_CONSOLE_MANAGER]*
					[$source EL_TITLED_TAB_BOOK_WINDOW]
		EV_FRAME
			[$source EL_FRAME]
		[$source EL_EXPANDED_CELL]
	EV_WIDGET_LIST*
		EV_BOX*
			EV_HORIZONTAL_BOX
				[$source EL_HORIZONTAL_BOX]
					[$source EL_SCROLLABLE_BOX]
						[$source EL_SCROLLABLE_VERTICAL_BOX]
							[$source EL_SCROLLABLE_SEARCH_RESULTS]
						[$source EL_SCROLLABLE_PAGE]
					[$source EL_AUTO_CELL_HIDING_HORIZONTAL_BOX]
					[$source EL_CENTERED_VERTICAL_BOX]
					[$source EL_MULTI_MODE_HTML_COLOR_SELECTOR_BOX]
					[$source EL_CONSOLE_MANAGER_TOOLBAR]
				[$source EL_DIRECTORY_USER_SELECT]
			EV_VERTICAL_BOX
				[$source EL_VERTICAL_BOX]
					[$source EL_AUTO_CELL_HIDING_VERTICAL_BOX]
				[$source EL_DOCKED_TAB_BOOK]
					[$source EL_SPLIT_AREA_DOCKED_TAB_BOOK]
				[$source EL_TOOL_BAR_RADIO_BUTTON_GRID]
			[$source EL_BOX]*
				[$source EL_HORIZONTAL_BOX]
				[$source EL_AUTO_CELL_HIDING_BOX]*
					[$source EL_AUTO_CELL_HIDING_HORIZONTAL_BOX]
					[$source EL_AUTO_CELL_HIDING_VERTICAL_BOX]
				[$source EL_VERTICAL_BOX]
		EV_NOTEBOOK
			[$source EL_FIXED_TAB_BOOK]*
			[$source EL_TAB_BOOK]
		EV_FIXED
			[$source EL_MIXED_STYLE_FIXED_LABELS]
````

## Vision2-X UI Extensions
Various extensions for the [EiffelVision2](https://www.eiffel.org/resources/libraries/eiffelvision2) library.
## Pango-Cairo 2D Graphics
Eiffel interface to the [Cairo 2D graphics library](https://cairographics.org/) providing advanced pixel buffer rendering with transparencies and anti-aliasing. See class [EL_DRAWABLE_PIXEL_BUFFER](http://www.eiffel-loop.com/library/graphic/toolkit/vision2-x/pango-cairo/el_drawable_pixel_buffer.html).
## Vision2-X UI Widget Extensions
Widgets extensions for the [EiffelVision2](https://www.eiffel.org/resources/libraries/eiffelvision2) library

**Drop-down Combo Boxes**


* Drop-downs linked to data containers conforming to `FINITE [G]` and initialized with a value of type *G*, and a selection change agent of type `PROCEDURE [G]`. See class [EL_DROP_DOWN_BOX](http://www.eiffel-loop.com/library/graphic/toolkit/vision2-x/widget/item-list/el_drop_down_box.html)
* Drop-downs with localized display strings. See class [EL_LOCALE_ZSTRING_DROP_DOWN_BOX](http://www.eiffel-loop.com/library/graphic/toolkit/vision2-x/widget/item-list/el_locale_zstring_drop_down_box.html)
* Drop downs for months of year specified as integers and displayed with English names and a localized variant [EL_LOCALE_ZSTRING_DROP_DOWN_BOX](http://www.eiffel-loop.com/library/graphic/toolkit/vision2-x/widget/item-list/el_locale_zstring_drop_down_box.html)

** Primitive Widget Descendants**


````
EV_PRIMITIVE*
	EV_LIST_ITEM_LIST*
		EV_COMBO_BOX
			[$source EL_COMBO_BOX]
				[$source EL_DROP_DOWN_BOX]
					[$source EL_ZSTRING_DROP_DOWN_BOX]
						[$source EL_LOCALE_ZSTRING_DROP_DOWN_BOX]
					[$source EL_MONTH_DROP_DOWN_BOX]
	EV_LABEL
		[$source EL_LABEL]
	EV_GAUGE*
		EV_RANGE*
			EV_VERTICAL_RANGE
				[$source EL_SCALE_SLIDER]
	EV_PIXMAP
		[$source EL_PIXMAP]
			[$source EL_DRAWING_PIXMAP]*
				[$source EL_LABEL_PIXMAP]
			[$source EL_SVG_PIXMAP]
				[$source EL_SVG_TEMPLATE_PIXMAP]
					[$source EL_STRETCHABLE_SVG_TEMPLATE_PIXMAP]
	EV_BUTTON
		EV_TOGGLE_BUTTON
			EV_CHECK_BUTTON
				[$source EL_CHECK_BUTTON]
			[$source EL_TOGGLE_BUTTON]
		[$source EL_DECORATED_BUTTON]
		[$source EL_COLOR_BUTTON]
	EV_TEXT_COMPONENT*
		EV_TEXT_FIELD
			EV_SPIN_BUTTON
			[$source EL_TEXT_FIELD]
				[$source EL_INPUT_FIELD]*
					[$source EL_INTEGER_INPUT_FIELD]
		EV_TEXT
			EV_RICH_TEXT
				[$source EL_RICH_TEXT]
					[$source EL_HTML_TEXT]
			[$source EL_TEXT]
		[$source EL_UNDOABLE_TEXT_COMPONENT]*
			[$source EL_TEXT_FIELD]
			[$source EL_TEXT]
	EV_DRAWING_AREA
		[$source EL_DRAWING_AREA_BASE]*
			[$source EL_DRAWING_AREA]
				[$source EL_DRAWING_AREA_LABEL]
			[$source EL_HYPERLINK_AREA]
				[$source EL_HTML_TEXT_HYPERLINK_AREA]
					[$source EL_SUPER_HTML_TEXT_HYPERLINK_AREA]
		[$source EL_RED_GREEN_STATUS_LIGHTS_DRAWING_AREA]
		[$source EL_TIMED_PROGRESS_BAR]
````

## Windows Eiffel Library Extensions
Extensions for [WEL GUI library](https://www.eiffel.org/doc/solutions/WEL).
## C/C++ and MS COM objects
Create Eiffel interfaces to C/C++ API's
## Java
A high-level framework for wrapping Java classes that adds a useful layer of abstraction to Eiffel Software's interface to the JNI ([Java Native Interface](https://en.wikipedia.org/wiki/Java_Native_Interface)) called [eiffel2java](https://www.eiffel.org/doc/solutions/Eiffel2Java).

**Features**
* Better Java environment discovery for initialization.
* Automates composition of JNI call signature strings.
* Automates cleanup of Java objects.

The framework is based on the concept of a Java agent that is similar to an Eiffel agent. You will find classes: [JAVA_FUNCTION](http://www.eiffel-loop.com/library/language_interface/Java/java_agents/java_function.html) and [JAVA_PROCEDURE](http://www.eiffel-loop.com/library/language_interface/Java/java_agents/java_procedure.html) that inherit [JAVA_ROUTINE](http://www.eiffel-loop.com/library/language_interface/Java/java_agents/java_routine.html). These agent classes automatically generate correct JNI call signatures. The library allows the creation of recursively wrapped classes where the arguments and return types to wrapped routines are themselves wrapped classes.

See [example/eiffel2java/eiffel2java.ecf](http://www.eiffel-loop.com/example/eiffel2java/eiffel2java.html) for an example of it's use.
## Python
Some extensions to Daniel Rodríguez's [PEPE library for Eiffel](https://github.com/finnianr/Eiffel-Loop/tree/master/contrib/Eiffel/PEPE). This library allows you to call Python objects from Eiffel. Here is one example to query ID3 tags in an MP3 file: [EL_EYED3_TAG](http://www.eiffel-loop.com/library/language_interface/Python/example/el_eyed3_tag.html).
## Matlab
**Status:** No longer maintained

An Eiffel interface to [Matlab](http://uk.mathworks.com/products/matlab/), a popular math orientated scripting language. This interface was developed with Matlab Version 6.5, VC++ 8.0 Express Edition and Windows XP SP2 and successfully used in a number of linguistic research projects.

**NOTE** This ECF is for documentation purposes only and will not compile.
## Praat-script
**Status:** No longer maintained

Eiffel interface to the Praat scripting language

[Praat](http://www.fon.hum.uva.nl/praat) is a free tool for doing acoustic and phonetic analysis and has it's own scripting language, Praat-script.

The `el_toolkit` utility has an option for converting the source code of Praat ver. 4.4 to compile with MSC. (Praat compiles "out of the box" with the mingw compiler, but at the time EiffelStudio didn't support mingw)

Developed with VC++ 8.0 Express Edition, Windows XP SP2, Praat source code version 4.4.30. The conversion tool will not work with later versions of Praat.

**NOTE** This ECF is for documentation purposes only and will not compile.
## Eiffel Remote Object Server (EROS)
EROS (for **E**iffel **R**emote **O**bject **S**erver), is an experimental an XML orientated remote procedure call application framework with an original protocol based purely on XML processing instructions rather that any special XML tags.

**Features**


* Easily create multi threaded XML-RPC applications in Eiffel.
* Allows standard XML documents (SVG, XHTML etc) to be turned into procedure calls with the addition of a single processing instruction.
* Based on framework that allows flexible mapping of XML data to native Eiffel objects. Represent your XML data in Eiffel any way you want. The fact that you only need to include as much data as you need makes it much more efficient than a DOM based approach.
* Deserialization (XML->Eiffel) uses declarative xpath to setter mapping arrays. Multi context mapping greatly simplifies deserialization of complex documents by eliminating the need for absolete XPaths. Instead a small number of XML contexts are defined and attribute mappings use relative xpaths.
* Serialization (Eiffel->XML) uses [Evolicity](http://www.eiffel-loop.com/library/evolicity.html) the Eiffel Loop templating mini-language. Evolicity is similar to [Apache Velocity](http://velocity.apache.org/) but supports multi-context serialization. This greatly simplifies serialization of complex Eiffel structures.
* Remotely accessible application components can be developed initially with a single threaded console test harness, and then later deployed on multi-threaded server with thread output and performance monitor.
* A server GUI controls startup/shutdown and thread log output context switching in command console. Context switching has browser like navigation controls and allows you to easily monitor a large number of threads.
* The server GUI monitors 11 different performance characteristics.

**Demo Applications**

Two demo applications are provided that do signal math including Fourier transformations based on Greg Lee's [Numeric Eiffel Library](https://teameiffel.blogspot.com/2006/04/greg-lees-numeric-eiffel-library.html).


1. [signal-math.ecf](http://www.eiffel-loop.com/example/net/EROS/signal-math/signal-math.html) is a multi-mode command-line application with 2 client modes and 2 server-test modes.
2. [signal-math-server.ecf](http://www.eiffel-loop.com/example/net/EROS/server/signal-math-server.html) performs the same calculations as the server mode of demo 1 but is multi-threaded and has a graphical user interface to control the thread logging context visible in terminal console.

**Build Notes**

When including the `eros.ecf` in your project it is necessary to define a custom variable `eros_server_enabled`. To build a server application set the value to `true`. To build a client application set value to `false`.


## Basic Networking Classes
* Extensions for ISE network sockets.
* Class to obtain the MAC address of network devices on both Windows and Linux.
* Classes for managing HTTP cookies, query parameters, headers and status codes.

## Adobe Flash to Laabhair
**Status:** No longer maintained

Eiffel network interface to [Flash ActionScript objects](https://github.com/finnianr/Eiffel-Loop/blob/master/Flash_library/eiffel_loop/laabhair) used in the **Laabhair** digital signal processing framework. This framework allows you to create applications that process speech with a [Praat](http://www.fon.hum.uva.nl/praat) script in real time and create visual representations of the the data using Adobe Flash. Depends on the Eiffel-Loop Praat-script interface library.

Developed on Windows XP SP2 with Flash Professional 8 IDE, EiffelStudio 6.1, VC++ 8.0 Express Edition.

Laabhair was developed at the [Digital Media Centre at the Dublin Institute of Technology](https://arrow.dit.ie/dmc/)
## Amazon Instant Access API
An Eiffel interface to the [Amazon Instant Access API](https://s3-us-west-2.amazonaws.com/dtg-docs/index.html). This API enables third party vendors to fulfil orders for digital goods on the Amazon store. It enables One-time purchases but not subscriptions. It passes a basic test suite but has not yet been tested in production.
## FTP Client Services
Classes providing


* uploading of files to a server
* managing server directory structure.
* file synchronization using the [EL_CRC_32_SYNC_ITEM](http://www.eiffel-loop.com/library/network/base/transfer-sync/el_crc_32_sync_item.html) abstraction

## PayPal Payments Standard Button Manager API
An Eiffel interface to the [PayPal Payments Standard Button Manager NVP HTTP API](https://developer.paypal.com/docs/classic/button-manager/integration-guide/).
## HTTP Client Services
Classes for remotely interacting with a HTTP server. Supports the HTTP commands: POST, GET and HEAD.
## Fast CGI Servlets
An implementation of the [Fast-CGI protocol](http://www.mit.edu/~yandros/doc/specs/fcgi-spec.html) for creating single and multi-threaded HTTP servlet services.
## Override of EiffelVision2
Override of Eiffel Software's EiffelVision2 for use with [Eiffel-Loop Vision2 extensions](http://www.eiffel-loop.com/library/vision2-x.html)
## Override of Eiffel2Java
Override of Eiffel Software's [Eiffel2Java](https://www.eiffel.org/doc/solutions/Eiffel2Java) library for use with the [Eiffel-Loop Eiffel to Java](http://www.eiffel-loop.com/library/eiffel2java.html) library.
## Eco-DB (Eiffel CHAIN Orientated Database)
*Eco-DB* is an acronym for *Eiffel CHAIN Orientated Database*. This library allows the extension (by inheritance) of a container object inheriting the base class [CHAIN](https://www.eiffel.org/files/doc/static/18.01/libraries/base/chain_chart.html) so that it assumes many of the charateristics of a database table.

**PERSISTENCE**

Of course this is the fundamental property of any database. *Eco-DB* offers 2 kinds of persistence:

**1. CHAIN level persistence**

This type of persistence involves storing the entire chain to a file in one operation. This is useful for data that is more or less static, like for example the localisation table [EL_TRANSLATION_ITEMS_LIST](http://www.eiffel-loop.com/library/text/i18n/support/el_translation_items_list.html). 

See class [ECD_CHAIN](http://www.eiffel-loop.com/library/persistency/database/eco-db/ecd_chain.html).

**2. item level persistence**

Item level, or "incremental persistence" is where the effects of any of the basic [CHAIN](https://www.eiffel.org/files/doc/static/18.01/libraries/base/chain_chart.html) operations `(extend/replace/delete**)` are recorded as they happen in a separate editions file. When the chain is loaded during object initialisation, a chain level store is loaded first, and then the stored editions are applied to bring the chain to it's final state.

See class [ECD_RECOVERABLE_CHAIN](http://www.eiffel-loop.com/library/persistency/database/eco-db/ecd_recoverable_chain.html) for more details.

**JOINING TABLES**

Being able to join*** tables via a common field is the essence of a relational database. *Eco-DB* offers a number of features that support the joining of chains.

**1. Field Indexing** 

For large number of chain items, performing joins can be slow without the use of field indices. Writing code to create and maintain fields manually is very time consuming, but fortunately *Eco-DB* offers an easy way to maintain field indices via the implementing class [ECD_ARRAYED_LIST](http://www.eiffel-loop.com/library/persistency/database/eco-db/ecd_arrayed_list.html) and it's reflective descendant: [ECD_REFLECTIVE_ARRAYED_LIST](http://www.eiffel-loop.com/library/persistency/database/eco-db/ecd_reflective_arrayed_list.html). See the class documentation for more details.

**2. Primary Keys**

Being able to assign a unique identifier to each item in a chain is essential to creating many kinds of data-joins. *Eco-DB* offers a convenient way to both generate primary keys and maintain an index for it. This is achieved with the auxilary class [ECD_PRIMARY_KEY_INDEXABLE](http://www.eiffel-loop.com/library/persistency/database/eco-db/index/ecd_primary_key_indexable.html) when used in conjunction with either [ECD_ARRAYED_LIST](http://www.eiffel-loop.com/library/persistency/database/eco-db/ecd_arrayed_list.html) or it's reflective descendant: [ECD_REFLECTIVE_ARRAYED_LIST](http://www.eiffel-loop.com/library/persistency/database/eco-db/ecd_reflective_arrayed_list.html).

**QUERY LANGUAGE**

Of course the Eiffel language itself can be used to query any [CHAIN](https://www.eiffel.org/files/doc/static/18.01/libraries/base/chain_chart.html) list, but sometimes the meaning of the query is obscured in implementation details. What is needed is a slightly more abstract way of expressing queries that makes the meaning more apparent. This is provided by the class [EL_QUERYABLE_CHAIN](http://www.eiffel-loop.com/library/base/data_structure/list/queryable/el_queryable_chain.html) and it's helper [EL_QUERY_CONDITION_FACTORY](http://www.eiffel-loop.com/library/base/data_structure/list/queryable/el_query_condition_factory.html). The implementing class [ECD_ARRAYED_LIST](http://www.eiffel-loop.com/library/persistency/database/eco-db/ecd_arrayed_list.html) inherits [EL_QUERYABLE_CHAIN](http://www.eiffel-loop.com/library/base/data_structure/list/queryable/el_queryable_chain.html).

Conditions can be combined using the logical operators: `and`, `or` and `not`. Queries are not parsed strings but actual Eiffel expressions. Some example of the expressiveness of this query language can be found in the following hierarchy of classes descended from [SONG_QUERY_CONDITIONS](http://www.eiffel-loop.com/example/manage-mp3/source/rhythmbox/database/song_query_conditions.html). See project [Eiffel-Loop/example/manage-mp3](http://www.eiffel-loop.com/example/manage-mp3/manage-mp3.html).

(Search source code pages for routine `query`)


````
SONG_QUERY_CONDITIONS
	[$source STORAGE_DEVICE]
		[$source SAMSUNG_TABLET_DEVICE]
		[$source NOKIA_PHONE_DEVICE]
		[$source TEST_STORAGE_DEVICE]
	[$source RBOX_DATABASE]
		[$source RBOX_TEST_DATABASE]
	[$source RBOX_MANAGEMENT_TASK]*
		[$source COLLATE_SONGS_TASK]
		[$source PUBLISH_DJ_EVENTS_TASK]
		[$source ID3_TASK]*
			[$source ADD_ALBUM_ART_TASK]
			[$source DELETE_COMMENTS_TASK]
			[$source DISPLAY_INCOMPLETE_ID3_INFO_TASK]
			[$source DISPLAY_MUSIC_BRAINZ_INFO_TASK]
			[$source NORMALIZE_COMMENTS_TASK]
			[$source PRINT_COMMENTS_TASK]
			[$source REMOVE_ALL_UFIDS_TASK]
			[$source REMOVE_UNKNOWN_ALBUM_PICTURES_TASK]
			[$source UPDATE_COMMENTS_WITH_ALBUM_ARTISTS_TASK]
		[$source UPDATE_DJ_PLAYLISTS_TASK]
			[$source UPDATE_DJ_PLAYLISTS_TEST_TASK]
		[$source IMPORT_NEW_MP3_TASK]
			[$source IMPORT_NEW_MP3_TEST_TASK]
		[$source DEFAULT_TASK]
		[$source ARCHIVE_SONGS_TASK]
		[$source IMPORT_VIDEOS_TASK]
			[$source IMPORT_VIDEOS_TEST_TASK]
		[$source REPLACE_CORTINA_SET_TASK]
			[$source REPLACE_CORTINA_SET_TEST_TASK]
		[$source REPLACE_SONGS_TASK]
			[$source REPLACE_SONGS_TEST_TASK]
		[$source RESTORE_PLAYLISTS_TASK]
		[$source EXPORT_TO_DEVICE_TASK]*
			[$source EXPORT_MUSIC_TO_DEVICE_TASK]
				[$source EXPORT_PLAYLISTS_TO_DEVICE_TASK]
					[$source EXPORT_PLAYLISTS_TO_DEVICE_TEST_TASK]
				[$source EXPORT_MUSIC_TO_DEVICE_TEST_TASK]
			[$source EXPORT_TO_DEVICE_TEST_TASK]*
				[$source EXPORT_MUSIC_TO_DEVICE_TEST_TASK]
				[$source EXPORT_PLAYLISTS_TO_DEVICE_TEST_TASK]
		[$source TEST_MANAGEMENT_TASK]*
			[$source EXPORT_TO_DEVICE_TEST_TASK]*
			[$source IMPORT_VIDEOS_TEST_TASK]
			[$source UPDATE_DJ_PLAYLISTS_TEST_TASK]
			[$source REPLACE_SONGS_TEST_TASK]
			[$source REPLACE_CORTINA_SET_TEST_TASK]
			[$source IMPORT_NEW_MP3_TEST_TASK]
		[$source IMPORT_M3U_PLAYLISTS_TASK]
````
**Foot Notes**

** `delete` is a routine from [ECD_CHAIN](http://www.eiffel-loop.com/library/persistency/database/eco-db/ecd_chain.html) and not from `CHAIN`.

*** We are using the term *join* somewhat loosely and mean only that if you have two chains *CHAIN [A]* and *CHAIN [B]*, you can produce a subchain of *CHAIN [B]* where each *B* item has a matching field value with an item from *CHAIN [A]*.


## Kindle Publishing
Classes for generating Kindle OPF packages from HTML content.
## Thunderbird Email Export
Classes to read and export emails from the [Thunderbird email client](https://www.thunderbird.net/) including a class to generate a Kindle book from a folder of chapter emails.

Test class [THUNDERBIRD_TEST_APP]($source)
## Open Office Spreadsheets
Classes for reading the contents of [OpenDocument Flat XML spreadsheets](http://www.datypic.com/sc/odf/e-office_spreadsheet.html) using [VTD-XML](http://vtd-xml.sourceforge.net/).

Test class [OPEN_OFFICE_TEST_APP]($source)
## Eiffel LIST-orientated XML Database
**Status:** No longer maintained

A simple XML database based on VTD-XML xpath and XML parsing library. Supports transactions and encryption. Any list conforming to `LIST [EL_STORABLE_XML_ELEMENT]` can be turned into a database. This library has now been superceded by [Eco-DB.ecf](http://www.eiffel-loop.com/library/Eco-DB.html) which is faster, more powerful and uses a binary format.
## Xpath Orientated Node-scanning and Object Building
This library has two major functions:


* Xpath orientated XML node scanners fed by 5 different types of XML node parse event generators.
* Recursive building of Eiffel objects from XML using Xpath expressions.

**XML Node Scanning**

The 5 parse event generators types, all descendants of class [EL_PARSE_EVENT_SOURCE](http://www.eiffel-loop.com/library/persistency/xml/xdoc-scanning/event-sources/el_parse_event_source.html), are as follows:

**1.** [EL_EXPAT_XML_PARSER](http://www.eiffel-loop.com/library/persistency/xml/xdoc-scanning/event-sources/expat-parser/el_expat_xml_parser.html): An Eiffel binding to the [eXpat XML parser](http://expat.sourceforge.net/)

**2.** [EL_EXPAT_XML_PARSER_OUTPUT_MEDIUM](http://www.eiffel-loop.com/library/persistency/xml/xdoc-scanning/event-sources/expat-parser/el_expat_xml_parser_output_medium.html): [eXpat XML parser](http://expat.sourceforge.net/) of XML serializeable objects conforming to `EVOLICITY_SERIALIZEABLE_AS_XML`.

**3.** [EL_EXPAT_XML_WITH_CTRL_Z_PARSER](http://www.eiffel-loop.com/library/persistency/xml/xdoc-scanning/event-sources/expat-parser/el_expat_xml_with_ctrl_z_parser.html): [eXpat XML parser](http://expat.sourceforge.net/) with input stream end delimited by Ctrl-Z character. Useful for parsing network streams.

**4.** [EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE](http://www.eiffel-loop.com/library/persistency/xml/xdoc-scanning/event-sources/binary-encoded/el_binary_encoded_xml_parse_event_source.html): a binary encoded XML event source. Useful for reducing the size of large documents.

**5.** [EL_PYXIS_PARSER](http://www.eiffel-loop.com/library/persistency/xml/xdoc-scanning/event-sources/pyxis/el_pyxis_parser.html) event from a [Pyxis format](https://www.eiffel.org/node/143) parser. Pyxis is a direct analog of XML that is easier to read and edit making it suitable for configuration files.



The following are the various kinds of scanners which can process the output from these event sources.

**Eiffel Object Building Scanners**

The classes [EL_BUILDABLE_FROM_XML](http://www.eiffel-loop.com/library/persistency/xml/xdoc-scanning/scanners/eiffel-object-building/buildable/el_buildable_from_xml.html) and [EL_BUILDABLE_FROM_PYXIS](http://www.eiffel-loop.com/library/persistency/xml/xdoc-scanning/scanners/eiffel-object-building/buildable/el_buildable_from_pyxis.html) can be used to implement a sophisticated Eiffel object building scheme based on the idea of mapping builder agents to xpaths relative to particular element contexts. Only a small subset of the xpath standard is used. The framework has the following features:


* Map particular XML element contexts to Eiffel classes and then map xpaths that are relative to these elements, to attribute assigning agents.
* Supports xpath mapping based on attribute value predicates, i.e. Expressions of the form **AAA/BBB[@x='y']** may be used to map building agents.
* Supports recursive data models.

**General Xpath to Eiffel agent mapper**

The class [EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS](http://www.eiffel-loop.com/library/persistency/xml/xdoc-scanning/scanners/xpath-scan/el_createable_from_xpath_match_events.html) implements a method for scanning a document and triggering various Eiffel agents according to a table of xpath to agent mappings.

**Eiffel Aware Document Scanner**

The class [EL_SMART_BUILDABLE_FROM_NODE_SCAN](http://www.eiffel-loop.com/library/persistency/xml/xdoc-scanning/scanners/eiffel-object-building/smart-builder/el_smart_buildable_from_node_scan.html) is an XML parser that reacts to a special XML processing instruction, telling it to build an Eiffel object of a particular type.


## XML Document Scanning and Object Building (VTD-XML)
Classes for scanning XML documents and building Eiffel objects from XML contexts defined by relative Xpaths. Based on the [VTD-XML parser](http://vtd-xml.sourceforge.net/). This is a full implemenation of Xpath 1.0.

VTD-XML uses a very fast and efficient method of building a compressed representation of an XML object using [virtual token descriptors](http://vtd-xml.sourceforge.net/VTD.html).

Using the Eiffel API is considerably easier and more intuitive to use than the original Java or C version of VTD-XML.

A substantial C-bridge was developed to make Eiffel work better with VTD-XML. The original VTX-XML code was forked to make it possible to compile it with the MSC compiler. This fork is found under `contrib/C`.

Test class [VTD_XML_TEST_APP]($source)
## Windows Registry Management
Classes for Windows registry searching, reading and editing.

This library adds a layer of abstraction to the Windows registry classes found the in the [Eiffel Windows Library WEL](https://www.eiffel.org/resources/libraries/wel). This abstraction layer makes it easier and more intuitive to search, read and edit Windows registry keys and data. See [this article](https://www.eiffel.org/article/windows_registry_access_made_easy) on Eiffel room.
## Multi-Application Management
This library has two main purposes:


1. Manage a collection of small (and possibility related) "mini-applications" as a single Eiffel application.
2. Implement the concept of a self-installing/uninstalling application on multiple-platforms.

**"Swiss-army-knife applications"**

Creating a new project application in Eiffel is expensive both in terms of time to create a new ECF and project directory structure, and in terms of diskspace. If all you want to do is create a small utility to do some relatively minor task, it makes sense to include it with a other such utilities in a single application. But you need some framework to manage all these sub-applications. In this package, the two classes [EL_MULTI_APPLICATION_ROOT](http://www.eiffel-loop.com/library/runtime/app-manage/multi-app/el_multi_application_root.html) and [EL_SUB_APPLICATION](http://www.eiffel-loop.com/library/runtime/app-manage/multi-app/sub-app/el_sub_application.html) provide this capability.

**Command line sub-applications**

The following features exist for creating command line applications:


* The class [EL_COMMAND_LINE_SUB_APPLICATION](http://www.eiffel-loop.com/library/runtime/app-manage/multi-app/sub-app/el_command_line_sub_application.html) provides a smart way of mapping command line arguments to the arguments of a creation procedure with automatic string conversion according to type.
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

Classes [EL_PROCEDURE_DISTRIBUTER](http://www.eiffel-loop.com/library/runtime/concurrency/communication/producer-consumer/distributer/el_procedure_distributer.html) and [EL_FUNCTION_DISTRIBUTER](http://www.eiffel-loop.com/library/runtime/concurrency/communication/producer-consumer/distributer/el_function_distributer.html) offer a convenient way to distribute the work of executing routines using a specific number of cores. See routine `read_source_files` in class [EIFFEL_CONFIGURATION_FILE](http://www.eiffel-loop.com/tool/eiffel/source/root/library/publish/eiffel_configuration_file.html) for an example.

**Producer-Consumer Framework**

A generic producer-consumer thread communication framework where a producing thread places products onto a queue for consumption by a consumer thread.

*Features*


* Implementation of a single consumer thread consuming the products of a single worker thread.
* Implementation of multiple consumer threads consuming the products of a single worker thread.
* Vision2 extension allowing products of a thread to be consumed by the main GUI application thread.
* Specialized consumer-producer thread classes for agent action consuming.

*Consumer Descendants*


````
EL_CONSUMER*
	[$source EL_NONE_CONSUMER]
	[$source EL_CONSUMER_MAIN_THREAD]*
		[$source EL_TUPLE_CONSUMER_MAIN_THREAD]
		[$source EL_COUNT_CONSUMER_MAIN_THREAD]*
			[$source EL_TIMED_PROCEDURE_MAIN_THREAD]
		[$source EL_PROCEDURE_CALL_CONSUMER_MAIN_THREAD]
		[$source EL_MAIN_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER]*
	[$source EL_COUNT_CONSUMER]*
		[$source EL_COUNT_CONSUMER_MAIN_THREAD]*
		[$source EL_TIMED_PROCEDURE]*
			[$source EL_TIMED_PROCEDURE_MAIN_THREAD]
			[$source EL_TIMED_PROCEDURE_THREAD]
		[$source EL_COUNT_CONSUMER_THREAD]*
			[$source EL_TIMED_PROCEDURE_THREAD]
	[$source EL_PROCEDURE_CALL_CONSUMER]*
		[$source EL_PROCEDURE_CALL_CONSUMER_MAIN_THREAD]
		[$source EL_PROCEDURE_CALL_CONSUMER_THREAD]
	[$source EL_REGULAR_INTERVAL_EVENT_CONSUMER]*
		[$source EL_MAIN_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER]*
		[$source EL_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER]*
	[$source EL_CONSUMER_THREAD]*
		[$source EL_PROCEDURE_CALL_CONSUMER_THREAD]
		[$source EL_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER]*
		[$source EL_COUNT_CONSUMER_THREAD]*
		[$source EL_MANY_TO_ONE_CONSUMER_THREAD]*
		[$source EL_DELEGATING_CONSUMER_THREAD]
````
*Product Queue Descendants*


````
EL_THREAD_PRODUCT_QUEUE
	[$source EL_ONE_TO_MANY_THREAD_PRODUCT_QUEUE]
	[$source EL_PROCEDURE_CALL_QUEUE]
````
**Specialized Threads**

The library includes many thread classes inheriting from [EL_IDENTIFIED_THREAD_I](http://www.eiffel-loop.com/library/runtime/concurrency/thread-types/el_identified_thread_i.html) that perform specialized tasks.

*Examples*


* Intermittently repeat an action with a specified sleep interval until signaled to stop.
* Continuously repeat an action until signaled to stop.
* Continuously repeat an action until receiving a signal to suspend or exit. Remains suspended unless signaled to resume or exit.

*Descendants*


````
EL_IDENTIFIED_THREAD_I*
	[$source EL_IDENTIFIED_MAIN_THREAD]
	[$source EL_IDENTIFIED_THREAD]*
		[$source EL_CONTINUOUS_ACTION_THREAD]*
			[$source EL_WORK_DISTRIBUTION_THREAD]
			[$source EL_RHYTHMIC_ACTION_THREAD]*
				[$source EL_TIMED_COUNT_PRODUCER]
				[$source EL_TIMEOUT]
			[$source EL_CONSUMER_THREAD]*
				[$source EL_PROCEDURE_CALL_CONSUMER_THREAD]
				[$source EL_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER]*
				[$source EL_COUNT_CONSUMER_THREAD]*
					[$source EL_TIMED_PROCEDURE_THREAD]
				[$source EL_MANY_TO_ONE_CONSUMER_THREAD]*
				[$source EL_DELEGATING_CONSUMER_THREAD]
				[$source EL_TUPLE_CONSUMER_THREAD]
			[$source EL_DORMANT_ACTION_LOOP_THREAD]*
				[$source EL_REGULAR_INTERVAL_EVENT_PRODUCER]
		[$source EL_WORKER_THREAD]
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


* By implementing the [EL_CONSOLE_MANAGER](http://www.eiffel-loop.com/library/runtime/logging/support/el_console_manager.html) class in a GUI library it is possible to create a UI component that is able to switch the logged console output to that of a different thread of execution. The [Vision2-x library](http://www.eiffel-loop.com/library/vision2-x.html) has once such component [EL_CONSOLE_MANAGER_TOOLBAR](http://www.eiffel-loop.com/library/graphic/toolkit/vision2-x/container/cell/box/special/el_console_manager_toolbar.html). See this example [screenshot](http://www.eiffel-loop.com/images/screenshot/console-thread-switch.png). The [wel-x library](http://www.eiffel-loop.com/library/wel-x.html) partially implements it with class [EL_CONSOLE_MANAGER_DIALOG](http://www.eiffel-loop.com/library/graphic/toolkit/wel-x/logging/el_console_manager_dialog.html).

**Output Format**

The beauty of Eiffel-Loop logging is that the output is indented to show the entry and exit from routines. Each entry and exit to a routine is documented with a header and trailer output text based on the class name and routine name. The following is some sample output from a test program for the [Eiffel Loop VTD-XML API](http://www.eiffel-loop.com/library/vtd-xml.html). The test function executes an xpath query looking for http urls in an XML document.




````
1>     VTD_XML_TEST_APP.test_bio_2 (
1>         argument (1) = "//value[@type='url' and contains (text(), 'http://')]"
1>     ) is
1>       doing
1>         
1>         EL_XPATH_ROOT_NODE_CONTEXT.context_list is
1>           doing
1>             
1>           end -- EL_XPATH_ROOT_NODE_CONTEXT
1>         http://iubio.bio.indiana.edu/grid/runner/
1>         http://iubio.bio.indiana.edu/grid/runner/docs/bix.dtd
1>         http://www-igbmc.u-strasbg.fr/BioInfo/ClustalW/
1>         http://geta.life.uiuc.edu/~gary/programs/fastDNAml.html
1>         
1>       end -- VTD_XML_TEST_APP
````
The code which produced the above output is as follows:


````
class
	VTD_XML_TEST_APP
````

````
inherit
	EL_SUB_APPLICATION
````

````
feature -- Basic operations
````

````
	test_bio_2 (xpath: STRING) is
		-- list all url values
		local
			node_list: EL_XPATH_NODE_CONTEXT_LIST
		do
			log.enter_with_args ("test_bio_2", << xpath >>)
			node_list := bio_info_root_node.context_list (xpath)
			from node_list.start until node_list.after loop
				log.put_line (node_list.context.string_value)
				node_list.forth
			end
			log.exit
		end
````

````
feature {NONE} -- Implementation
````

````
	bio_info_root_node: EL_XPATH_ROOT_NODE_CONTEXT
````
Note that each logged routine must start and finish with a paired call to enter_with_args and exit and that the first argument to enter_with_args matches the name of the routine. The log object maintains a logging call stack. A call to enter_with_args pushes a new routine onto the stack and exit pops the entry. The second argument is of type `ARRAY [ANY]` and is used to log any routine arguments. Routine enter_with_args calls the out function from the universal ancestor class `ANY` for each of the array items and lists them each on a separate line as argument (1), argument (2) etc.

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

There are a number of ways to include logging in your application. The first is to inherit [EL_LOGGED_SUB_APPLICATION](http://www.eiffel-loop.com/library/runtime/logging/el_logged_sub_application.html) in your root class and implement the function `Log_filter` (see below). You must then make sure that init_logging is the first routine called in the application entry make procedure. A slightly simpler way is to inherit from class [EL_SUB_APPLICATION](http://www.eiffel-loop.com/library/runtime/app-manage/multi-app/sub-app/el_sub_application.html) in your root class. This class has a make procedure already defined which calls init_logging, you only have to implement the procedures initialize and run. The routine make must be listed as a creation procedure.

Inheriting from class [EL_SUB_APPLICATION](http://www.eiffel-loop.com/library/runtime/app-manage/multi-app/sub-app/el_sub_application.html) has some incidental benefits including:


* Graceful handling of the ctrl-c program interrupt with the possibility of putting application cleanup into a redefinition of procedure `on_operating_system_signal`.


* Integration with the Eiffel Loop multi mode application framework. This framework allows you to select from different applications by a command line switch. Useful for managing many small applications that hardly justify the disk resources of a separate project.

To including logging facilities in any class, inherit from class [EL_MODULE_LOG](http://www.eiffel-loop.com/library/runtime/logging/el_module_log.html) and add an entry for that class in the log filter array. (see below)

By default logging is not active in the application. It must be turned on using the `-logging` command line switch.

**Log output filtering**

The logging framework offers a simple way to filter the output by class and routine. The root class of your application should inherit class [EL_LOGGED_SUB_APPLICATION](http://www.eiffel-loop.com/library/runtime/logging/el_logged_sub_application.html) and implement the routine `Log_filter` as a once function returning an array of tuples. The `Log_filter` for class [TEST_VTD_XML_APP]($source) is implemented as follows:


````
feature {NONE} -- Constants
````

````
	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{TEST_VTD_XML_APP}, All_routines]
			>>
		end
````
Each tuple in the array consists of the name of the class you wish to enable logging for, followed either by a list of individual routines or a `All_routines` to indicate that any and all routines are to be logged for that class. You can disable logging for any particular routine by prefixing the name with a hyphen. In the case of a wildcard, prefixing with a hyphen disables all logging for that class. The class filter is compared only with the generating class name so all child classes in a particular inheritance tree must be listed individually.

**Command Options**

A list of command options which effect the logging system can be found in class [EL_LOG_COMMAND_OPTIONS](http://www.eiffel-loop.com/library/runtime/logging/support/el_log_command_options.html).

**User step-through logging**

For debugging purposes you may wish to pause execution on the exit of each logged routine. The following call causes the application to stop execution on the exit of every logged routine and prompts the user to press enter to continue:


````
Logging.set_prompt_user_on_exit (true)
````
The logging object is available in the root class or by inheriting [EL_MODULE_LOGGING](http://www.eiffel-loop.com/library/runtime/logging/el_module_logging.html).

**Logging threads**

Logging a separate thread just requires that you inherit from [EL_LOGGED_IDENTIFIED_THREAD](http://www.eiffel-loop.com/library/runtime/logging/concurrency/thread-type/el_logged_identified_thread.html) and make sure the routine `on_start` gets called. It will anyway unless you do something to over-ride this routine.


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

A generic synchronization monitor allows synchronization on an object to be protected with a contract requiring that the object is locked before being referenced. It is integrated with the logging framework to help detect deadlock conditions. If a thread needs to wait for a lock on a synchronized object, both the waiting and acquiring of the lock is logged in the thread's log. See class [EL_LOGGED_MUTEX_REFERENCE](http://www.eiffel-loop.com/library/runtime/logging/concurrency/el_logged_mutex_reference.html)

**Logging Routines**

Access to the logging routines is through feature log of class [EL_MODULE_LOG](http://www.eiffel-loop.com/library/runtime/logging/el_module_log.html). The log object conforms to type [EL_LOGGABLE](http://www.eiffel-loop.com/library/base/runtime/io/logging/el_loggable.html) which has numerous procedures for writing to the log as well as some useful functions.

The procedure form: 


````
put_<lowercase type name>
````
is use to output the following types: `STRING, INTEGER, CHARACTER, REAL and DOUBLE`.

The procedure form:


````
put_<lowercase type name>_field
````
is used to output the following types prefixed with a field label: `STRING, INTEGER, INTEGER_INTERVAL, REAL and DOUBLE`.

The procedure `put_string_field_to_max_length` is used to output a multi-line block of text in abbreviated form. The beginning and last 30 characters of the string is output up to a maximum number of characters (or 1/3 of the maximum length, whichever is smaller). If the text contains more than one line, tab indents are inserted to left align the text to the correct logging indent. The boolean function `current_routine_is_active` can be tested in order to conditionally execute a block of code if the current routine is unfiltered by any routine filter.

**Always on logging**

Class [EL_MODULE_LOG](http://www.eiffel-loop.com/library/runtime/logging/el_module_log.html) also has a special logging object named `lio`, short for "log or io". This is used in the same way as the usual log object with the difference that the output will still be written to the console even if logging is globally disabled. It can be used to write to the console instead of the usual io medium from class `ANY`.

**Log files**

All log files are put in a sub directory logs of the current working directory. If you are making your application loggable using [EL_SUB_APPLICATION](http://www.eiffel-loop.com/library/runtime/app-manage/multi-app/sub-app/el_sub_application.html) then these log files are automatically deleted when the application exits. If you want a chance to inspect the log files in an editor before they disappear there are a number of ways to do this:

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


* Automatic escaping of path arguments conforming to [EL_PATH](http://www.eiffel-loop.com/library/base/text/file-naming/el_path.html), namely [EL_FILE_PATH](http://www.eiffel-loop.com/library/base/text/file-naming/el_file_path.html) and [EL_DIR_PATH](http://www.eiffel-loop.com/library/base/text/file-naming/el_dir_path.html). All Windows paths are automatically put in quotes. Unix paths are automatically escaped with \ for reserved characters. This has some advantages over putting them in quotes.


* Designed for cross platform use, with special features for post-capture processing of output lines so they are consistent across platforms. See classes [EL_FIND_DIRECTORIES_COMMAND_I](http://www.eiffel-loop.com/library/runtime/process/commands/system/file/find/el_find_directories_command_i.html) and [EL_FIND_FILES_COMMAND_I](http://www.eiffel-loop.com/library/runtime/process/commands/system/file/find/el_find_files_command_i.html) as an example. Here the Unix `find` command and the Windows `dir` command are made to appear exactly the same for specific tasks.


* Support for making "convenience wrappers" without any need to create a new class. These are classes: [EL_OS_COMMAND](http://www.eiffel-loop.com/library/runtime/process/commands/kernel/el_os_command.html) and [EL_CAPTURED_OS_COMMAND](http://www.eiffel-loop.com/library/runtime/process/commands/kernel/el_captured_os_command.html).


* Has factory class [EL_OS_ROUTINES_IMP](http://www.eiffel-loop.com/library/runtime/process/commands/imp_mswin/system/el_os_routines_imp.html) (accessible via [EL_MODULE_OS](http://www.eiffel-loop.com/library/runtime/process/commands/system/el_module_os.html)) which contains factory functions for common OS system commands.

**Information Commands**

These are "out of the box" command for obtaining system information.


* Unix command to parse output of nm-tool to get MAC address of ethernet devices


* Unix command to obtain CPU name


## Development Testing
* Regression tests based on CRC checksum comparisons of logging output and output files. These are used extensively in Eiffel-Loop projects.
* Helper classes for unit tests based on `EQA_TEST_SET`

## Internationalization
An internationalization library with support for translations rendered in Pyxis format. There are a number of tools in `el_toolkit` to support the use of this library.
## AES Encryption
Easy interface to basic AES encryption with extensions to Colin LeMahieu's [AES encryption library](https://github.com/EiffelSoftware/EiffelStudio/tree/master/Src/contrib/library/text/encryption/eel). Includes a class for reading and writing encrypted files using [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) cipher [block chains](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation).
## RSA Public-key Encryption
Extends Colin LeMahieu's arbitrary precision integer library to conform to some RSA standards. The most important is the ability to read key-pairs conforming to the [X509 PKCS1 standard](https://en.wikipedia.org/wiki/X.509#Sample_X.509_certificates). The top level class to access these facilities is [EL_MODULE_X509_COMMAND](http://www.eiffel-loop.com/library/text/rsa-encryption/x509/el_module_x509_command.html).

The private key reader however uses a non-standard encryption scheme. It assumes the file is en	crypted using the Eiffel-Loop utility contained in `el_toolkit`.


## Evolicity Text Substitution Engine
*Evolicity* is a text substitution language that was inspired by the [Velocity text substitution language](http://velocity.apache.org/) for Java. *Evolicity* provides a way to merge the data from Eiffel objects into a text template. The template can be either supplied externally or hard-coded into an Eiffel class. The language includes, substitution variables, conditional statements and loops. Substitution variables have a BASH like syntax. Conditionals and loops have an Eiffel like syntax.

The text of this web site was generated by the Eiffel-view repository publisher (See class [REPOSITORY_PUBLISHER_APP]($source)) using the following combination of *Evolicity* templates:


1. [doc-config/main-template.html.evol](https://github.com/finnianr/Eiffel-Loop/blob/master/doc-config/main-template.html.evol)
2. [doc-config/site-map-content.html.evol](https://github.com/finnianr/Eiffel-Loop/blob/master/doc-config/site-map-content.html.evol)
3. [doc-config/directory-tree-content.html.evol](https://github.com/finnianr/Eiffel-Loop/blob/master/doc-config/directory-tree-content.html.evol)
4. [doc-config/eiffel-source-code.html.evol](https://github.com/finnianr/Eiffel-Loop/blob/master/doc-config/eiffel-source-code.html.evol)

To make an Eiffel class serializable with *Evolicity* you inherit from class [EVOLICITY_SERIALIZEABLE](http://www.eiffel-loop.com/library/text/template/evolicity/serialization/evolicity_serializeable.html). Read the class notes for details on how to use. You can also access the substitution engine directly from the shared instance in class [EL_MODULE_EVOLICITY_TEMPLATES](http://www.eiffel-loop.com/library/text/template/evolicity/el_module_evolicity_templates.html)

**Features**


* Templates are compiled to an intermediate byte code stored in `.evc` files. This saves time consuming lexing operations on large templates.
* Has a class [EVOLICITY_CACHEABLE_SERIALIZEABLE](http://www.eiffel-loop.com/library/text/template/evolicity/serialization/evolicity_cacheable_serializeable.html) for caching the substituted output. Useful for generating pages on a web-server.




## Search Engine
Classes for parsing search terms and searching a list conforming to `CHAIN [EL_WORD_SEARCHABLE]` using case-insensitive word tokenization.


* Facility to create custom search types.
* Terms can be combined using basic boolean operators.

See [myching.software](http://myching.software/en/home/my-ching.html) for an example of a commercial application that makes use of this library.
## Textual Data Formats
Classes for handling various human-readable text formats. Supported formats are: XML, XHTML, HTML, JSON, CSV. (Note: Eiffel-Loop has other libraries for parsing XML)
## Text Editing
Classes for editing file and other text.
## Parsing
Classes for parsing text data.
## Pattern-matching
Classes for finding and matching textual patterns.
## Application License Management
A few basic classes for constructing an application license manager. The most important is a way to obtain a unique machine ID using a combination of the CPU model name and MAC address either from the network card or wifi card.

The principle developer of Eiffel-loop has developed a sophisticated license management system using RSA public key cryptography, however it is not available as open source. If you are interested to license this system for your company, please contact the developer. It has been used for the [My Ching](http://myching.software) software product.
## ZLib Compression
An Eiffel interface to the [zlib C library](https://www.zlib.net/). The main class is [EL_COMPRESSED_ARCHIVE_FILE](http://www.eiffel-loop.com/library/utility/compression/el_compressed_archive_file.html) with a few helper classes.
## Currency Exchange
Currency Exchange based on European Central bank Rates from [eurofxref-daily.xml](https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml)
## Windows Installer
**Status:** No longer maintained.

Classes to create a Windows install program.

This library has been superceded by the capabilities of the [Multi-Application Management](http://www.eiffel-loop.com/library/app-manage.html) library.
## Eiffel Development Utilities
A "Swiss-army knife" of Eiffel development utilities invokeable by a command-line switch.

**Sub-applications**

`-eiffel_view`: [EIFFEL_VIEW_APP](http://www.eiffel-loop.com/tool/eiffel/source/root/apps/eiffel_view_app.html)

A sub-application to publish source code and descriptions of Eiffel projects to a website as static html and generate a `Contents.md` file in Github markdown. See [eiffel.org article](https://www.eiffel.org/blog/Finnian%20Reilly/2018/10/eiffel-view-repository-publisher-version-1-0-18)

`-generate_codecs`: [CODEC_GENERATOR_APP](http://www.eiffel-loop.com/tool/eiffel/source/root/apps/codec_generator_app.html)

Generate Eiffel classes conforming to [EL_ZCODEC](http://www.eiffel-loop.com/library/base/text/zstring/codec/el_zcodec.html) from VTD-XML C code

`-ecf_to_pecf`: [ECF_TO_PECF_APP](http://www.eiffel-loop.com/tool/eiffel/source/root/apps/ecf_to_pecf_app.html)

Convert Eiffel configuration files to Pyxis format

`-library_override`: [LIBRARY_OVERRIDE_APP](http://www.eiffel-loop.com/tool/eiffel/source/root/apps/library_override_app.html)

Generates override of standard libaries to work with Eiffel-Loop

`-expand_links`: [REPOSITORY_NOTE_LINK_CHECKER_APP](http://www.eiffel-loop.com/tool/eiffel/source/analyse/apps/repository_note_link_checker_app.html)

Use a supplied repository publishing configuration to expand `$source` variable path in wiki-links  containined in a wiki-markup text file. Write the expanded output to file named as follows:


````
<file name>.expanded.<file extension>

````
An incidental function is to expand all tabs as 3 spaces.

`-normalize_class_file_name`: [SOURCE_FILE_NAME_NORMALIZER_APP](http://www.eiffel-loop.com/tool/eiffel/source/root/apps/source_file_name_normalizer_app.html)

Normalize class filenames as lowercase classnames within a source directory

`normalize_imp_location` [IMP_CLASS_LOCATION_NORMALIZER_APP](http://www.eiffel-loop.com/tool/eiffel/source/root/apps/imp_class_location_normalizer_app.html)

Normalizes location of implementation classes in relation to respective interfaces for all projects listed in publisher configuration.

**Download**

Download binary of [`el_eiffel`](https://github.com/finnianr/Eiffel-Loop/releases/latest) for *Ubuntu 14.04* or *Linux Mint 17.x*.


## Eiffel Class Editing Utilities
A "Swiss-army knife" of Eiffel class editing utilities invokeable by a command-line switch.

**Sub-applications**

`-remove_prefix`: [CLASS_PREFIX_REMOVAL_APP](http://www.eiffel-loop.com/tool/eiffel/source/edit/apps/class_prefix_removal_app.html)

Removes all classname prefixes over a source directory

`-edit_notes`: [NOTE_EDITOR_APP](http://www.eiffel-loop.com/tool/eiffel/source/edit/apps/note_editor_app.html)

Add default values to note fields using a source tree manifest.

`-feature_edit`: [FEATURE_EDITOR_APP](http://www.eiffel-loop.com/tool/eiffel/source/edit/apps/feature_editor_app.html)

Expands Eiffel shorthand code in source file and reorders feature blocks alphabetically.

`-find_replace`: [FIND_AND_REPLACE_APP](http://www.eiffel-loop.com/tool/eiffel/source/edit/apps/find_and_replace_app.html)

Finds and replaces text in Eiffel source files specified by a source tree manifest

`-elog_remover`: [SOURCE_LOG_LINE_REMOVER_APP](http://www.eiffel-loop.com/tool/eiffel/source/edit/apps/source_log_line_remover_app.html)

Comment out logging lines from Eiffel source code tree

`-class_rename`: [SOURCE_TREE_CLASS_RENAME_APP](http://www.eiffel-loop.com/tool/eiffel/source/edit/apps/source_tree_class_rename_app.html)

Rename classes defined by a source manifest file

**Download**

Download binary of [`el_eiffel`](https://github.com/finnianr/Eiffel-Loop/releases/latest) for *Ubuntu 14.04* or *Linux Mint 17.x*.


## Eiffel Class Analysis Utilities
A "Swiss-army knife" of Eiffel class analysis utilities invokeable by a command-line switch.

**Sub-applications**

`-check_locale_strings`: [CHECK_LOCALE_STRINGS_APP](http://www.eiffel-loop.com/tool/eiffel/source/analyse/apps/check_locale_strings_app.html)

Verify localization translation identifiers against various kinds of source texts.

`-descendants`: [CLASS_DESCENDANTS_APP](http://www.eiffel-loop.com/tool/eiffel/source/analyse/apps/class_descendants_app.html)

Output a list of descendants for a class as an Eiffel note field that can be copy/pasted into Eiffel source code.

`-codebase_stats`: [CODEBASE_STATISTICS_APP](http://www.eiffel-loop.com/tool/eiffel/source/analyse/apps/codebase_statistics_app.html)

Count classes, code words and combined source file size for Eiffel source trees specified in manifest

`-check_encoding`: [ENCODING_CHECK_APP](http://www.eiffel-loop.com/tool/eiffel/source/analyse/apps/encoding_check_app.html)

Checks for UTF-8 files that could be encoded as Latin-1

`-check_note_links`: [REPOSITORY_NOTE_LINK_CHECKER_APP](http://www.eiffel-loop.com/tool/eiffel/source/analyse/apps/repository_note_link_checker_app.html)

Checks for invalid class references in repository note links

`-undefine_counter`: [UNDEFINE_PATTERN_COUNTER_APP](http://www.eiffel-loop.com/tool/eiffel/source/analyse/apps/undefine_pattern_counter_app.html)

Count the number of classes in the source tree manifest that exhibit multiple inheritance of classes with an identical pattern of feature undefining.

**Download**

Download binary of [`el_eiffel`](https://github.com/finnianr/Eiffel-Loop/releases/latest) for *Ubuntu 14.04* or *Linux Mint 17.x*.


## Utilities Toolkit
A "Swiss-army knife" of command line utilities accessible via a command line option.

The most useful ones are listed below with the option name:

`-body_word_counts` [HTML_BODY_WORD_COUNTER_APP](http://www.eiffel-loop.com/tool/toolkit/source/apps/html/html_body_word_counter_app.html)

Counts the number of words in a HTML document.

`-crypto`: [CRYPTO_COMMAND_SHELL_APP](http://www.eiffel-loop.com/tool/toolkit/source/apps/crypto_command_shell_app.html)

Menu driven shell of useful cryptographic operations.

`-export_book`: [THUNDERBIRD_BOOK_EXPORTER_APP](http://www.eiffel-loop.com/tool/toolkit/source/apps/thunderbird_book_exporter_app.html)

Merges a localized folder of emails in the Thunderbird email client into a single HTML book with chapter numbers and titles derived from subject line. The output files are used to generate a Kindle book.

`-export_www`: [THUNDERBIRD_WWW_EXPORTER_APP](http://www.eiffel-loop.com/tool/toolkit/source/apps/html/thunderbird_www_exporter_app.html)

Exports emails from selected Thunderbird email folders as HTML bodies (extension: `body`). As the name implies, only the body of the HTML is preserved. A matching folder structure is also created. This is useful for HTML content managers.

`-compile_translations`: [PYXIS_TRANSLATION_TREE_COMPILER_APP](http://www.eiffel-loop.com/tool/eiffel/source/root/apps/pyxis_translation_tree_compiler_app.html)

Compiles tree of Pyxis translation files into multiple locale files named `locale.x` where `x` is a 2 letter country code. Does nothing if source files are all older than locale files. See class [EL_LOCALE_I](http://www.eiffel-loop.com/library/text/i18n/el_locale_i.html).

`-pyxis_to_xml`: [PYXIS_TO_XML_APP](http://www.eiffel-loop.com/tool/toolkit/source/apps/pyxis/pyxis_to_xml_app.html)

Converts Pyxis format to XML with special support for Eiffel configuration files in Pyxis format (extension `pecf`). The attribute `configuration_ns` can be used as convenient shorthand for the ECF schema configuration information.

`-youtube_dl` [YOUTUBE_VIDEO_DOWNLOADER_APP](http://www.eiffel-loop.com/tool/toolkit/source/apps/youtube_video_downloader_app.html)

Download and merge selected audio and video streams from a Youtube video.

`-file_manifest` [FILE_MANIFEST_APP](http://www.eiffel-loop.com/tool/toolkit/source/apps/file_manifest_app.html)

Creates an XML file manifest of a target directory using either the default Evolicity template or an optional external Evolicity template. See class [EVOLICITY_SERIALIZEABLE](http://www.eiffel-loop.com/library/text/template/evolicity/serialization/evolicity_serializeable.html)

`-undated_photos` [UNDATED_PHOTO_FINDER_APP](http://www.eiffel-loop.com/tool/toolkit/source/apps/undated_photo_finder_app.html)

Lists JPEG photos that lack the EXIF field `Exif.Photo.DateTimeOriginal`.

`-duplicity` [DUPLICITY_BACKUP_APP](http://www.eiffel-loop.com/tool/toolkit/source/apps/duplicity_backup_app.html)

Create an duplicity backup using a configuration file in Pyxis format.

`-duplicity_restore` [DUPLICITY_RESTORE_APP](http://www.eiffel-loop.com/tool/toolkit/source/apps/duplicity_restore_app.html)

Restores either an entire duplicity backup or a selected file or directory.  Restoration output directory is defined in same configuration file as backup.

**Download**

Download binary of [`el_toolkit`](https://github.com/finnianr/Eiffel-Loop/releases/latest) for *Ubuntu 14.04* or *Linux Mint 17.x*.


## amazon-instant-access.ecf
Tests for Eiffel interface to Amazon Instant Access API. See class [AMAZON_INSTANT_ACCESS_TEST_APP]($source)
## base.ecf (Eiffel-Loop)
Test Eiffel-Loop base classes. See [BASE_AUTOTEST_APP](http://www.eiffel-loop.com/test/source/base/base_autotest_app.html)
## Benchmarking Tests
**Sub-applications**


* [ZSTRING_BENCHMARK_APP](http://www.eiffel-loop.com/test/source/benchmark/apps/zstring_benchmark_app.html) does performance testing of class [EL_ZSTRING](http://www.eiffel-loop.com/library/base/text/zstring/el_zstring.html)
* [BENCHMARK_APP](http://www.eiffel-loop.com/test/source/benchmark/apps/benchmark_app.html) compares performance of related routines with [EL_BENCHMARK_COMPARISON](http://www.eiffel-loop.com/library/base/utility/benchmark/el_benchmark_comparison.html). The benchmarks are run from a menu shell.

**Descendants of EL_BENCHMARK_COMPARISON**


````
[$source EL_BENCHMARK_COMPARISON]*
	[$source LIST_ITERATION_COMPARISON]
	[$source STRING_CONCATENATION_COMPARISON]
	[$source STRING_BENCHMARK_COMPARISON]*
		[$source REPLACE_SUBSTRING_COMPARISON]
		[$source SUBSTRING_INDEX_COMPARISON]
	[$source SET_ROUTINE_ARGUMENT_COMPARISON]
````

## compression.ecf
See class [COMPRESSION_TEST_APP](http://www.eiffel-loop.com/test/source/compression/compression_test_app.html)
## encryption.ecf
See class [ENCRYPTION_AUTOTEST_APP](http://www.eiffel-loop.com/test/source/encryption/app/encryption_autotest_app.html)
## eros.ecf
Test [Eiffel Remote Object Server (EROS)](http://www.eiffel-loop.com/library/eros.html) protocol library.

**Test Apps**


* [EROS_AUTOTEST_APP](http://www.eiffel-loop.com/test/source/eros/apps/eros_autotest_app.html)
* [BEXT_CLIENT_TEST_APP](http://www.eiffel-loop.com/test/source/eros/apps/bext_client_test_app.html)
* [BEXT_SERVER_TEST_APP](http://www.eiffel-loop.com/test/source/eros/apps/bext_server_test_app.html)
* [FOURIER_MATH_CLIENT_TEST_APP](http://www.eiffel-loop.com/test/source/eros/apps/fourier_math_client_test_app.html)
* [FOURIER_MATH_SERVER_TEST_APP](http://www.eiffel-loop.com/test/source/eros/apps/fourier_math_server_test_app.html)

## evolicity.ecf
Test of Evolicity text substitution engine. See class [EVOLICITY_TEST_APP](http://www.eiffel-loop.com/test/source/evolicity/evolicity_test_app.html)
## ftp.ecf
See class [FTP_AUTOTEST_APP](http://www.eiffel-loop.com/test/source/ftp/ftp_autotest_app.html)
## http-client.ecf
See class [HTTP_CLIENT_AUTOTEST_APP](http://www.eiffel-loop.com/test/source/http-client/http_client_autotest_app.html)
## i18n.ecf
Test localization library. See class [I18N_AUTOTEST_APP](http://www.eiffel-loop.com/test/source/i18n/i18n_autotest_app.html)
## ID3-tags.ecf
See class [ID3_TAGS_AUTOTEST_APP](http://www.eiffel-loop.com/test/ID3-tags/source/id3_tags_autotest_app.html)

Due to C name space clashes with `TagLib.ecf` these tests have been separated from `test.ecf`
## image-utils.ecf
See class [SVG_TO_PNG_CONVERSION_TEST_APP]($source)
## markup-docs.ecf
* Test subject line decoding for Thunderbird Email Export with [THUNDERBIRD_TEST_APP]($source)
* Regression test reading of Open Office Spreadsheet with [OPEN_OFFICE_TEST_APP]($source)

## multimedia.ecf
* Test wav to mp3 conversion

## network.ecf
Test network library classes


* [TEST_SIMPLE_CLIENT]($source)
* [SIMPLE_SERVER_TEST_APP]($source)

## os-command.ecf
* Test OS command interface library. See class [OS_COMMAND_AUTOTEST_APP](http://www.eiffel-loop.com/test/source/os-command/os_command_autotest_app.html)
* Test set for classes that manage and read file system content. See class [FILE_AND_DIRECTORY_TEST_SET](http://www.eiffel-loop.com/test/source/os-command/test-set/file_and_directory_test_set.html)

## paypal-SBM.ecf
Tests for Eiffel interface to PayPal Payments Standard Button Manager API. See class [PAYPAL_STANDARD_BUTTON_MANAGER_TEST_APP]($source)
## Root class and Experiments
Root class [APPLICATION_ROOT](http://www.eiffel-loop.com/test/source/root/application_root.html) and a collection of developer experiments to verify understanding of ISE base classes.

**Autotest Sub-applications**


````
EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION*
	[$source AMAZON_INSTANT_ACCESS_AUTOTEST_APP]
	[$source BASE_AUTOTEST_APP]
	[$source EROS_AUTOTEST_APP]
	[$source FTP_AUTOTEST_APP]
	[$source HTTP_CLIENT_AUTOTEST_APP]
	[$source I18N_AUTOTEST_APP]
	[$source ID3_TAGS_AUTOTEST_APP]
	[$source OS_COMMAND_AUTOTEST_APP]
	[$source PAYPAL_STANDARD_BUTTON_MANAGER_TEST_APP]
	[$source SEARCH_ENGINE_AUTOTEST_APP]
	[$source TAGLIB_AUTOTEST_APP]
	[$source TEXT_FORMATS_AUTOTEST_APP]
	[$source TEXT_PROCESS_AUTOTEST_APP]
	[$source EL_REGRESSION_AUTOTEST_SUB_APPLICATION]*
		[$source OPEN_OFFICE_AUTOTEST_APP]
		[$source VTD_XML_AUTOTEST_APP]
		[$source IMAGE_UTILS_AUTOTEST_APP]
		[$source XDOC_SCANNING_AUTOTEST_APP]
	[$source ENCRYPTION_AUTOTEST_APP]
	[$source THUNDERBIRD_AUTOTEST_APP]
````
**Regression Test Sub-applications**


````
EL_REGRESSION_TESTABLE_SUB_APPLICATION*
	[$source TEST_SUB_APPLICATION]*
		[$source MEDIA_PLAYER_DUMMY_APP]
		[$source COMPRESSION_TEST_APP]
		[$source EVOLICITY_TEST_APP]
		[$source SIMPLE_CLIENT_SERVER_TEST_APP]
````
**General Test Sub-applications**


````
EL_SUB_APPLICATION*
	[$source EL_LOGGED_SUB_APPLICATION]*
		[$source EXPERIMENTS_APP]
		[$source BEXT_CLIENT_TEST_APP]
		[$source FOURIER_MATH_CLIENT_TEST_APP]
		[$source TEST_WORK_DISTRIBUTER_APP]
		[$source EROS_SERVER_SUB_APPLICATION]*
			[$source BEXT_SERVER_TEST_APP]
			[$source FOURIER_MATH_SERVER_TEST_APP]
		[$source ZSTRING_BENCHMARK_APP]
	[$source EL_COMMAND_LINE_SUB_APPLICATION]*
		[$source EL_COMMAND_SHELL_SUB_APPLICATION]*
			[$source BENCHMARK_APP]
````
**Test Sets**


````
EQA_TEST_SET*
	[$source URI_ENCODING_TEST_SET]
	[$source DIGEST_ROUTINES_TEST_SET]
	[$source DIR_URI_PATH_TEST_SET]
	[$source GENERAL_TEST_SET]
	[$source PATH_STEPS_TEST_SET]
	[$source REFLECTION_TEST_SET]
	[$source STRING_EDITION_HISTORY_TEST_SET]
	[$source STRING_EDITOR_TEST_SET]
	[$source SE_ARRAY2_TEST_SET]
	[$source STRING_32_ROUTINES_TEST_SET]
	[$source TEMPLATE_TEST_SET]
	[$source ZSTRING_TOKEN_TABLE_TEST_SET]
	[$source STRING_LIST_TEST_SET]
	[$source EROS_TEST_SET]
	[$source COMMA_SEPARATED_IMPORT_TEST_SET]
	[$source JSON_NAME_VALUE_LIST_TEST_SET]
	[$source SETTABLE_FROM_JSON_STRING_TEST_SET]
	[$source PYXIS_PARSER_TEST_SET]
	[$source DATE_TEXT_TEST_SET]
	[$source SUBSTITUTION_TEMPLATE_TEST_SET]
	[$source ZSTRING_TEST_SET]
	[$source EL_SUBJECT_LINE_DECODER_TEST_SET]
	[$source PAYPAL_TEST_SET]
	[$source EQA_SYSTEM_TEST_SET]*
	[$source EL_EQA_TEST_SET]
		[$source EL_FILE_DATA_TEST_SET]
			[$source EL_COPIED_FILE_DATA_TEST_SET]*
				[$source ID3_TAG_INFO_TEST_SET]
				[$source TAGLIB_TEST_SET]
				[$source XML_TO_PYXIS_CONVERTER_TEST_SET]
				[$source PYXIS_TO_XML_TEST_SET]
			[$source EL_GENERATED_FILE_DATA_TEST_SET]*
				[$source REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_SET]
				[$source MODULE_CRC_32_TEST_SET]
				[$source AUDIO_COMMAND_TEST_SET]
				[$source OS_COMMAND_TEST_SET]
				[$source HELP_PAGES_TEST_SET]*
					[$source FTP_TEST_SET]
					[$source FILE_TREE_INPUT_OUTPUT_COMMAND_TEST_SET]
					[$source FILE_AND_DIRECTORY_TEST_SET]
				[$source HTTP_CONNECTION_TEST_SET]
				[$source SEARCH_ENGINE_TEST_SET]
					[$source ENCRYPTED_SEARCH_ENGINE_TEST_SET]
				[$source AMAZON_INSTANT_ACCESS_TEST_SET]
				[$source IMAGE_UTILS_TEST_SET]
				[$source OBJECT_BUILDER_TEST_SET]
		[$source EIFFEL_LOOP_TEST_SET]
			[$source CREATEABLE_FROM_XPATH_MATCH_EVENTS_TEST_SET]
			[$source PATH_TEST_SET]
			[$source TRANSLATION_TABLE_TEST_SET]
			[$source ENCRYPTION_TEST_SET]
			[$source OPEN_OFFICE_TEST_SET]
			[$source VTD_XML_TEST_SET]
		[$source CHAIN_TEST_SET]
			[$source WIDGET_TEST_SET]
		[$source EL_EQA_REGRESSION_TEST_SET]
			[$source CREATEABLE_FROM_XPATH_MATCH_EVENTS_TEST_SET]
			[$source OPEN_OFFICE_TEST_SET]
			[$source XML_TO_PYXIS_CONVERTER_TEST_SET]
			[$source VTD_XML_TEST_SET]
			[$source PYXIS_TO_XML_TEST_SET]
			[$source IMAGE_UTILS_TEST_SET]
			[$source OBJECT_BUILDER_TEST_SET]
	[$source SEQUENTIAL_INTERVALS_TEST_SET]
	[$source EL_TEST_DATA_TEST_SET]*
	[$source EIFFEL_NAME_TRANSLATEABLE_TEST_SET]
	[$source UC_UTF8_STRING_TEST_SET]
	[$source TEXT_PARSER_TEST_SET]
	[$source ARRAYED_LIST_TEST_SET]
````

## search-engine.ecf
See class [SEARCH_ENGINE_AUTOTEST_APP](http://www.eiffel-loop.com/test/source/search-engine/search_engine_autotest_app.html)
## TagLib.ecf
See class [TAGLIB_AUTOTEST_APP](http://www.eiffel-loop.com/test/source/TagLib/taglib_autotest_app.html)
## text-formats.ecf
See class [TEXT_FORMATS_AUTOTEST_APP](http://www.eiffel-loop.com/test/source/text-formats/text_formats_autotest_app.html)
## text-process.ecf
See class [TEXT_PROCESS_AUTOTEST_APP](http://www.eiffel-loop.com/test/source/text-process/text_process_autotest_app.html)
## thread.ecf
See class [TEST_WORK_DISTRIBUTER_APP]($source)
## vtd-xml.ecf
Tests for Eiffel interface VTD-XML C API

See class [VTD_XML_AUTOTEST_APP](http://www.eiffel-loop.com/test/source/vtd-xml/apps/vtd_xml_autotest_app.html)
## wel-x-audio.ecf
Maintenance of Windows audio classes See class [MEDIA_PLAYER_DUMMY_APP](http://www.eiffel-loop.com/test/source/wel-x-audio/imp_mswin/media_player_dummy_app.html)
## xdoc-scanning.ecf
Test application class: [XDOC_SCANNING_AUTOTEST_APP](http://www.eiffel-loop.com/test/source/xdoc-scanning/xdoc_scanning_autotest_app.html)
