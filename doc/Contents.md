# Eiffel-Loop Contents
## EROS Protocol Test server
Signal processing application to demonstrate the [EROS remote object protocol](http://www.eiffel-loop.com/library/eros.html).
## EROS Protocol Test clients
Client application to demonstrate remote signal processing math using the [EROS remote object protocol](http://www.eiffel-loop.com/library/eros.html).
## Submission for 99-bottles-of-beer.net
Eiffel submission for [www.99-bottles-of-beer.net](http://www.99-bottles-of-beer.net/).

This website contains sample programs for over 1500 languages and variations, all of which print the lyrics of the song "99 Bottles of Beer".
## Eiffel to Java
Demonstration program for the [Eiffel-Loop Java interface library](http://www.eiffel-loop.com/library/eiffel2java.html). This library provides a useful layer of abstraction over the Eiffel Software JNI interface.
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

For details on how to use, read the source documentation notes in class [RHYTHMBOX_MUSIC_MANAGER_APP](http://www.eiffel-loop.com/example/manage-mp3/source/sub-applications/rhythmbox_music_manager_app.html).

**Download**

Download the latest executable for *Ubuntu 14.04* or *Linux Mint 17.x* at the bottom of [this page](https://github.com/finnianr/Eiffel-Loop/releases/latest). You also need the following command line tools to be installed: `sox, swgen, avconv, lame, gvfs-mount`.

Warning: **Use at your own risk.** It is recommended that you have a backup of your MP3 collection and rhythmbox configuration files (Usually in `$HOME/.local/share/rhythmbox`). The developer does not take any responsibility for any data loss that may occur as a result of using *el_rhythmbox*.


## Vision-2 Extensions Demo
Test application for selected components from Eiffel-Loop [extension libraries for Vision-2 and Docking](http://www.eiffel-loop.com/library/vision2-x.html).
## Eiffel Development Utility
A "Swiss-army knife" of useful Eiffel command line development tools. The most useful ones are listed here with command line switchs:

`-publish_repository`: [REPOSITORY_PUBLISHER_APP](http://www.eiffel-loop.com/tool/eiffel/source/apps/repository/repository_publisher_app.html)

Publishes an Eiffel code repository as a website with module descriptions.

`-edit_notes`: [NOTE_EDITOR_APP](http://www.eiffel-loop.com/tool/eiffel/source/apps/editing/note_editor_app.html)

Add default values to note fields using a source tree manifest.

`-feature_edit`: [FEATURE_EDITOR_APP](http://www.eiffel-loop.com/tool/eiffel/source/apps/editing/feature_editor_app.html)

Expands Eiffel shorthand code in source file and reorders feature blocks alphabetically.

**Download**

Download binary of [`el_eiffel`](https://github.com/finnianr/Eiffel-Loop/releases/latest) for *Ubuntu 14.04* or *Linux Mint 17.x*.


## Utilities Toolkit
A "Swiss-army knife" of command line utilities accessible via a command line option. The most useful ones are listed belowe with the option name:

`-crypto`: [CRYPTO_APP](http://www.eiffel-loop.com/tool/toolkit/source/apps/crypto_app.html)

Menu driven shell of useful cryptographic operations.

`-pyxis_to_xml`: [PYXIS_TO_XML_APP](http://www.eiffel-loop.com/tool/toolkit/source/apps/pyxis/pyxis_to_xml_app.html)

Converts Pyxis format to XML with special support for Eiffel configuration files in Pyxis format (extension `pecf`). The attribute `configuration_ns` can be used as convenient shorthand for the ECF schema configuration information.

`-export_www`: [THUNDERBIRD_WWW_EXPORTER_APP](http://www.eiffel-loop.com/tool/toolkit/source/apps/html/thunderbird_www_exporter_app.html)

Exports emails from selected Thunderbird email folders as HTML bodies (extension: `body`). As the name implies, only the body of the HTML is preserved. A matching folder structure is also created. This is useful for HTML content managers.

`-compile_translations`: [PYXIS_TRANSLATION_TREE_COMPILER_APP](http://www.eiffel-loop.com/tool/toolkit/source/apps/pyxis/pyxis_translation_tree_compiler_app.html)

Compiles tree of Pyxis translation files into multiple locale files named `locale.x` where `x` is a 2 letter country code. Does nothing if source files are all older than locale files. See class [EL_LOCALE_I](http://www.eiffel-loop.com/library/text/i18n/el_locale_i.html).

`-youtube_dl` [YOUTUBE_HD_DOWNLOAD_COMMAND](http://www.eiffel-loop.com/tool/toolkit/source/command/youtube_hd_download_command.html)

Download and merge selected audio and video streams from a Youtube video.

`-file_manifest` [EL_FILE_MANIFEST_COMMAND](http://www.eiffel-loop.com/library/runtime/process/commands/file-management/el_file_manifest_command.html)

Creates an XML file manifest of a target directory using either the default Evolicity template or an optional external Evolicity template. See class [EVOLICITY_SERIALIZEABLE](http://www.eiffel-loop.com/library/text/template/evolicity/serialization/evolicity_serializeable.html)

`-undated_photos` [UNDATED_PHOTOS_COMMAND](http://www.eiffel-loop.com/tool/toolkit/source/command/undated_photos_command.html)

Lists JPEG photos that lack the EXIF field `Exif.Photo.DateTimeOriginal`.

**Download**

Download binary of [`el_toolkit`](https://github.com/finnianr/Eiffel-Loop/releases/latest) for *Ubuntu 14.04* or *Linux Mint 17.x*.


## Eiffel-Loop Dev Tests
## ID3 Tagging for MP3
Classes for reading and writing ID3 tags to MP3 files using a common interface to the C libraries `libid3tag (C)` and `id3lib (C++)`. The former C library is used for ID3 version 2.4 tags and the latter for earlier versions from 2.0 to 2.3.
## WAV Audio Processing
Classes for reading and writing wav files on the Windows OS
## Windows Audio
Audio extensions for the [WEL GUI library](https://www.eiffel.org/doc/solutions/WEL) that facilitate playback and other audio functions.
## Vision2 Audio
Audio extensions for Windows implementation of Vision2 GUI library. This depends on the [WEL audio extensions](http://www.eiffel-loop.com/library/wel-x-audio.html) library.
## Laabhair Audio
**Status:** No longer maintained

The Laabhair* Audio library was developed at the [Digital Media Centre at the Dublin Institute of Technology](https://arrow.dit.ie/dmc/) to do audio processing with Eiffel and present realtime graphics audio representations using an [Adobe Flash player](https://www.adobe.com/products/flashplayer.html) GUI.

*Laabhair is the Gaelic for talk.
## Data Structure
## Math
## Data Persistence
Classes for reading and writing data to files
## Runtime
## Text Processing
Classes for parsing and processing textual data
## Utility
Utility classes providing the following


1. Benchmarking
2. Date/time formatting
3. Memory writing
4. Cyclic redundancy check
5. Command shells
6. Extensions to ES uuid.ecf

## Image Utilities
Image utilities providing:


1. SVG to PNG conversion using C library [librsvg](http://librsvg.sourceforge.net/)
2. Miscellaneous routines from the [Cairo graphics C library](https://cairographics.org/)

## HTML Viewer (based on Vision-2)
Extension for Vision2 library to render very basic html produced by Thunderbird email client.
## EiffelVision 2 GUI Extensions
Extensions to the Eiffel Software [Vision-2 cross-platform GUI library](https://www.eiffel.org/doc/solutions/EiffelVision%202) and the [Smart Docking library](https://dev.eiffel.com/Smart_Docking_library).

**Features**

These are some highlights of a long list of features:


* Advanced pixel buffer rendering with transparencies and anti-aliasing using the [Cairo](https://cairographics.org/) and [Pangocairo](http://www.pango.org/) 2D graphics library. See class [EL_DRAWABLE_PIXEL_BUFFER](http://www.eiffel-loop.com/library/graphic/toolkit/vision2-x/interface/widgets/primitives/pixmap/el_drawable_pixel_buffer.html)
* Drop-down combo boxes linked to data containers conforming to `FINITE [G]` and initialized with a value of type *G*, and a selection change agent of type `PROCEDURE [G]`. See class [EL_DROP_DOWN_BOX](http://www.eiffel-loop.com/library/graphic/toolkit/vision2-x/interface/widgets/primitives/drop-downs/el_drop_down_box.html)
* Drop-down combo boxes with localized display strings. See class [EL_LOCALE_ZSTRING_DROP_DOWN_BOX](http://www.eiffel-loop.com/library/graphic/toolkit/vision2-x/interface/widgets/primitives/drop-downs/el_locale_zstring_drop_down_box.html)
* Drop down combo box for months of year specified as integers and displayed with English names and a localized variant [EL_LOCALE_ZSTRING_DROP_DOWN_BOX](http://www.eiffel-loop.com/library/graphic/toolkit/vision2-x/interface/widgets/primitives/drop-downs/el_locale_zstring_drop_down_box.html)






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
## Eiffel Remote Object Server (EROS)
EROS is an acronym for **E**iffel **R**emote **O**bject **S**erver and is an experimental project that implements an Eiffel orientated XML remote procedure call protocol.

The two example projects demonstrate an [EROS client](http://www.eiffel-loop.com/example/net/EROS/test-clients/source/sub-applications/fourier_math_test_client_app.e.html) calling an [EROS server](http://www.eiffel-loop.com/example/net/EROS/server/source/sub-applications/fourier_math_server_app.e.html) using the EROS protocol.

The server program has an optional GUI mode that allows real time monitoring of network service threads with thread logging displayed in the console. Thread context switching is controlled by the graphical interface as shown in [this screenshot](http://www.eiffel-loop.com/images/screenshot/console-thread-switch.png). Note that this shot was taken before the introduction of console color-highlighting to Eiffel-Loop.

The network protocol operates in two alternative modes (set by a command switch):

**1.** plain text XML

**2.** binary compressed XML

**Build Notes**

When including the `eros.ecf` in your project it is necessary to define a custom variable `eros_server_enabled`. To build a server application set the value to `true`. To build a client application set value to `false`.








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
* file synchronization using the [EL_CRC_32_SYNC_ITEM](http://www.eiffel-loop.com/library/base/runtime/file/transfer-sync/el_crc_32_sync_item.html) abstraction

## PayPal Payments Standard Button Manager API
An Eiffel interface to the [PayPal Payments Standard Button Manager NVP HTTP API](https://developer.paypal.com/docs/classic/button-manager/integration-guide/).
## HTTP Client Services
Classes for remotely interacting with a HTTP server. Supports the HTTP commands: POST, GET and HEAD.
## Fast CGI Servlets
An implementation of the [Fast-CGI protocol](http://www.mit.edu/~yandros/doc/specs/fcgi-spec.html) for creating single and multi-threaded HTTP servlet services.
## Eco-DB (Eiffel CHAIN Orientated Database)
*Eco-DB* is an acronym for *Eiffel CHAIN Orientated Database*, and enables the development of container objects conforming to the base class [CHAIN](https://www.eiffel.org/files/doc/static/18.01/libraries/base/chain_chart.html) to have many of the properties of relational database tables.

**PERSISTENCE**

Of course this is the fundamental property of any database. *Eco-DB* offers 2 kinds of persistence:

**1. CHAIN level persistence**

This type of persistence involves storing the entire chain to a file in one operation. This is useful for data that is more or less static, like for example the localization table [EL_TRANSLATION_ITEMS_LIST](http://www.eiffel-loop.com/library/text/i18n/support/el_translation_items_list.html). 

See class [ECD_CHAIN](http://www.eiffel-loop.com/library/persistency/database/eco-db/ecd_chain.html).

**2. item level persistence**

Item level, or "incremental persistence" is where the effects of any of the basic [CHAIN](https://www.eiffel.org/files/doc/static/18.01/libraries/base/chain_chart.html) operations `(extend/replace/delete**)` are recorded as they happen in a separate editions file. When the chain is loaded during object initialization, a chain level store is loaded first, and then the stored editions are applied to bring the chain to it's final state.

See class [ECD_RECOVERABLE_CHAIN](http://www.eiffel-loop.com/library/persistency/database/eco-db/ecd_recoverable_chain.html) for more details.

**JOINING TABLES**

Being able to join*** tables via a common field is the essence of a relational database. *Eco-DB* offers a number of features that support the joining of chains.

**1. Field Indexing** 

For large number of chain items, performing joins can be slow without the use of field indices. Writing code to create and maintain fields manually is very time consuming, but fortunately *Eco-DB* offers an easy way to maintain field indices via the implementing class [ECD_ARRAYED_LIST](http://www.eiffel-loop.com/library/persistency/database/eco-db/ecd_arrayed_list.html) and it's reflective descendant: [ECD_REFLECTIVE_ARRAYED_LIST](http://www.eiffel-loop.com/library/persistency/database/eco-db/ecd_reflective_arrayed_list.html). See the class documentation for more details.

**2. Primary Keys**

Being able to assign a unique identifier to each item in a chain is essential to creating many kinds of data-joins. *Eco-DB* offers a convenient way to both generate primary keys and maintain an index for it. This is achieved with the auxilary class [ECD_PRIMARY_KEY_INDEXABLE](http://www.eiffel-loop.com/library/persistency/database/eco-db/index/ecd_primary_key_indexable.html) when used in conjunction with either [ECD_ARRAYED_LIST](http://www.eiffel-loop.com/library/persistency/database/eco-db/ecd_arrayed_list.html) or it's reflective descendant: [ECD_REFLECTIVE_ARRAYED_LIST](http://www.eiffel-loop.com/library/persistency/database/eco-db/ecd_reflective_arrayed_list.html).

**QUERY LANGUAGE**

Of course the Eiffel language itself can be used to query any [CHAIN](https://www.eiffel.org/files/doc/static/18.01/libraries/base/chain_chart.html) list, but sometimes the meaning of the query is obscured in implementation details. What is needed is a slightly more abstract way of expressing queries that makes the meaning more apparent. This is provided by the class [EL_QUERYABLE_CHAIN](http://www.eiffel-loop.com/library/base/data_structure/list/queryable/el_queryable_chain.html) and it's helper [EL_QUERY_CONDITION_FACTORY](http://www.eiffel-loop.com/library/base/data_structure/list/queryable/el_query_condition_factory.html). The implementing class [ECD_ARRAYED_LIST](http://www.eiffel-loop.com/library/persistency/database/eco-db/ecd_arrayed_list.html) inherits [EL_QUERYABLE_CHAIN](http://www.eiffel-loop.com/library/base/data_structure/list/queryable/el_queryable_chain.html).

Conditions can be combined using the logical operators: `and`, `or` and `not`. Queries are not parsed strings but actual Eiffel expressions. Some example of the expressiveness of this query language can be found in the following list of classes from the example project [Eiffel-Loop/example/manage-mp3](http://www.eiffel-loop.com/example/manage-mp3/manage-mp3.html):

(Search page for routine `do_query`)


* [SONG_QUERY_CONDITIONS](http://www.eiffel-loop.com/example/manage-mp3/source/rhythmbox/database/song_query_conditions.html)
* [RHYTHMBOX_MUSIC_MANAGER](http://www.eiffel-loop.com/example/manage-mp3/source/rhythmbox/manager/rhythmbox_music_manager.html)
* [TEST_MUSIC_MANAGER](http://www.eiffel-loop.com/example/manage-mp3/source/rhythmbox/test/test_music_manager.html)

**Foot Notes**

** `delete` is a routine from [ECD_CHAIN](http://www.eiffel-loop.com/library/persistency/database/eco-db/ecd_chain.html) and not from `CHAIN`.

*** We are using the term *join* somewhat loosely and mean only that if you have two chains *CHAIN [A]* and *CHAIN [B]*, you can produce a subchain of *CHAIN [B]* where each *B* item has a matching field value with an item from *CHAIN [A]*.


## Search Engine Classes
Classes for parsing search terms and searching a list conforming to `CHAIN [EL_WORD_SEARCHABLE]`. The search uses case-insensivitive word tokenization.


* Facility to create custom search types.
* Terms can be combined using basic boolean operators.

## Windows Registry Management
Classes for Windows registry searching, reading and editing.

This library adds a layer of abstraction to the Windows registry classes found the in the [Eiffel Windows Library WEL](https://www.eiffel.org/resources/libraries/wel). This abstraction layer makes it easier and more intuitive to search, read and edit Windows registry keys and data. See [this article](https://www.eiffel.org/article/windows_registry_access_made_easy) on Eiffel room.
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
## Markup Document Processing
Classes for processing documents encoded with various kinds of markup language.

**1.** [OpenDocument Flat XML spreadsheets](http://www.datypic.com/sc/odf/e-office_spreadsheet.html) using [VTD-XML](http://vtd-xml.sourceforge.net/).

**2.** Read and export emails from the [Thunderbird email client](https://www.thunderbird.net/) including a class to generate a Kindle book from a folder of chapter emails.

**3.** Classes for generating Kindle OPF packages from HTML content.
## Multi-Application Management
This library has two main purposes:


1. Manage a collection of small (and possibility related) "mini-applications" as a single Eiffel application.
2. Implement the concept of a self-installing/uninstalling application on multiple-platforms.

**"Swiss-army-knife applications"**

Creating a new project application in Eiffel is expensive both in terms of time to create a new ECF and project directory structure, and in terms of diskspace. If all you want to do is create a small utility to do some relatively minor task, it makes sense to include it with a other such utilities in a single application. But you need some framework to manage all these sub-applications. In this package, the two classes [EL_MULTI_APPLICATION_ROOT](http://www.eiffel-loop.com/library/runtime/app-manage/el_multi_application_root.html) and [EL_SUB_APPLICATION](http://www.eiffel-loop.com/library/runtime/app-manage/sub-app/el_sub_application.html) provide this capability.

**Command line sub-applications**

The following features exist for creating command line applications:


* The class [EL_COMMAND_LINE_SUB_APPLICATION](http://www.eiffel-loop.com/library/runtime/app-manage/sub-app/el_command_line_sub_application.html) provides a smart way of mapping command line arguments to the arguments of a creation procedure with automatic string conversion according to type.
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
Classes augmenting the classic [EiffelThread library](https://www.eiffel.org/doc/solutions/EiffelThreads). Of these, the most useful are [EL_PROCEDURE_DISTRIBUTER](http://www.eiffel-loop.com/library/runtime/concurrency/communication/producer-consumer/distributer/el_procedure_distributer.html) and [EL_FUNCTION_DISTRIBUTER](http://www.eiffel-loop.com/library/runtime/concurrency/communication/producer-consumer/distributer/el_function_distributer.html) which offers a convenient way to distribute the work of executing routines using a specific number of cores. See routine `read_source_files` in class [EIFFEL_CONFIGURATION_FILE](http://www.eiffel-loop.com/tool/eiffel/source/library/publish/eiffel_configuration_file.html) for an example.
## Multi-threaded Logging
Logging library featuring color highlighted output and mimicry of Eiffel routine code in output.

**General Features**


* Output is indented to reflect the state of the call stack. Shows the entry and exit from routines in a way that is designed to mimic the routines code definition.


* On Unix platforms console output is syntax high-lighted by default. See this [screenshot](http://www.eiffel-loop.com/images/screenshot/color-highlighting.png).


* Global filtering mechanism to restrict output to selected classes and routines. A wildcard constant can be used to log all routines for a particular class.


* By implementing the [EL_CONSOLE_MANAGER](http://www.eiffel-loop.com/library/runtime/logging/support/el_console_manager.html) class in a GUI library it is possible to create a UI component that is able to switch the logged console output to that of a different thread of execution. The [Vision2-x library](http://www.eiffel-loop.com/library/vision2-x.html) has once such component [EL_CONSOLE_MANAGER_TOOLBAR](http://www.eiffel-loop.com/library/graphic/toolkit/vision2-x/interface/logging/el_console_manager_toolbar.html). See this example [screenshot](http://www.eiffel-loop.com/images/screenshot/console-thread-switch.png). The [wel-x library](http://www.eiffel-loop.com/library/wel-x.html) partially implements it with class [EL_CONSOLE_MANAGER_DIALOG](http://www.eiffel-loop.com/library/graphic/toolkit/wel-x/logging/el_console_manager_dialog.html).

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

There are a number of ways to include logging in your application. The first is to inherit [EL_LOGGED_SUB_APPLICATION](http://www.eiffel-loop.com/library/runtime/logging/el_logged_sub_application.html) in your root class and implement the function `Log_filter` (see below). You must then make sure that init_logging is the first routine called in the application entry make procedure. A slightly simpler way is to inherit from class [EL_SUB_APPLICATION](http://www.eiffel-loop.com/library/runtime/app-manage/sub-app/el_sub_application.html) in your root class. This class has a make procedure already defined which calls init_logging, you only have to implement the procedures initialize and run. The routine make must be listed as a creation procedure.

Inheriting from class [EL_SUB_APPLICATION](http://www.eiffel-loop.com/library/runtime/app-manage/sub-app/el_sub_application.html) has some incidental benefits including:


* Graceful handling of the ctrl-c program interrupt with the possibility of putting application cleanup into a redefinition of procedure `on_operating_system_signal`.


* Integration with the Eiffel Loop multi mode application framework. This framework allows you to select from different applications by a command line switch. Useful for managing many small applications that hardly justify the disk resources of a separate project.

To including logging facilities in any class, inherit from class [EL_MODULE_LOG](http://www.eiffel-loop.com/library/runtime/logging/el_module_log.html) and add an entry for that class in the log filter array. (see below)

By default logging is not active in the application. It must be turned on using the `-logging` command line switch.

**Log output filtering**

The logging framework offers a simple way to filter the output by class and routine. The root class of your application should inherit class [EL_LOGGED_SUB_APPLICATION](http://www.eiffel-loop.com/library/runtime/logging/el_logged_sub_application.html) and implement the routine `Log_filter` as a once function returning an array of tuples. The `Log_filter` for class [TEST_VTD_XML_APP](http://www.eiffel-loop.com/test/source/apps/xml/test_vtd_xml_app.html) is implemented as follows:


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
**Logging Routines**

Access to the logging routines is through feature log of class [EL_MODULE_LOG](http://www.eiffel-loop.com/library/runtime/logging/el_module_log.html). The log object conforms to type [EL_LOGGABLE](http://www.eiffel-loop.com/library/base/runtime/io/loggable/el_loggable.html) which has numerous procedures for writing to the log as well as some useful functions.

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

All log files are put in a sub directory logs of the current working directory. If you are making your application loggable using [EL_SUB_APPLICATION](http://www.eiffel-loop.com/library/runtime/app-manage/sub-app/el_sub_application.html) then these log files are automatically deleted when the application exits. If you want a chance to inspect the log files in an editor before they disappear there are a number of ways to do this:

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


* Has factory class [EL_OS_ROUTINES_IMP](http://www.eiffel-loop.com/library/runtime/process/commands/spec/unix/system/el_os_routines_imp.html) (accessible via [EL_MODULE_OS](http://www.eiffel-loop.com/library/runtime/process/commands/system/el_module_os.html)) which contains factory functions for common OS system commands.

**Information Commands**

These are "out of the box" command for obtaining system information.


* Unix command to parse output of nm-tool to get MAC address of ethernet devices


* Unix command to obtain CPU name


## Regression Testing
Classes for doing regression tests based on CRC checksum comparisons of logging output and output files.
## Internationalization
An internationalization library with support for translations rendered in Pyxis format. There are a number of tools in `el_toolkit` to support the use of this library.
## AES Encryption
Easy interface to basic AES encryption with extensions to Colin LeMahieu's [AES encryption library](https://github.com/EiffelSoftware/EiffelStudio/tree/master/Src/contrib/library/text/encryption/eel). Includes a class for reading and writing encrypted files using [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) cipher [block chains](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation).
## RSA Public-key Encryption
Extends Colin LeMahieu's arbitrary precision integer library to conform to some RSA standards. The most important is the ability to read key-pairs conforming to the [X509 PKCS1 standard](https://en.wikipedia.org/wiki/X.509#Sample_X.509_certificates). The top level class to access these facilities is [EL_MODULE_X509_COMMAND](http://www.eiffel-loop.com/library/text/rsa-encryption/x509/el_module_x509_command.html).

The private key reader however uses a non-standard encryption scheme. It assumes the file is en	crypted using the Eiffel-Loop utility contained in `el_toolkit`. See class [CRYPTO_APP](http://www.eiffel-loop.com/tool/toolkit/source/apps/crypto_app.html) for details. (Missing file?)
## Evolicity Text Substitution Engine
*Evolicity* is a text substitution language that was inspired by the [Velocity text substitution language](http://velocity.apache.org/) for Java. *Evolicity* provides a way to merge the data from Eiffel objects into a text template. The template can be either supplied externally or hard-coded into an Eiffel class. The language includes, substitution variables, conditional statements and loops. Substitution variables have a BASH like syntax. Conditionals and loops have an Eiffel like syntax.

The text of this web site was generated by the Eiffel-view repository publisher (See class [REPOSITORY_PUBLISHER_APP](http://www.eiffel-loop.com/tool/eiffel/source/apps/repository/repository_publisher_app.html)) using the following combination of *Evolicity* templates:


1. [doc-config/main-template.html.evol](https://github.com/finnianr/Eiffel-Loop/blob/master/doc-config/main-template.html.evol)
2. [doc-config/site-map-content.html.evol](https://github.com/finnianr/Eiffel-Loop/blob/master/doc-config/site-map-content.html.evol)
3. [doc-config/directory-tree-content.html.evol](https://github.com/finnianr/Eiffel-Loop/blob/master/doc-config/directory-tree-content.html.evol)
4. [doc-config/eiffel-source-code.html.evol](https://github.com/finnianr/Eiffel-Loop/blob/master/doc-config/eiffel-source-code.html.evol)

To make an Eiffel class serializable with *Evolicity* you inherit from class [EVOLICITY_SERIALIZEABLE](http://www.eiffel-loop.com/library/text/template/evolicity/serialization/evolicity_serializeable.html). Read the class notes for details on how to use. You can also access the substitution engine directly from the shared instance in class [EL_MODULE_EVOLICITY_TEMPLATES](http://www.eiffel-loop.com/library/text/template/evolicity/el_module_evolicity_templates.html)

**Features**


* Templates are compiled to an intermediate byte code stored in `.evc` files. This saves time consuming lexing operations on large templates.
* Has a class [EVOLICITY_CACHEABLE_SERIALIZEABLE](http://www.eiffel-loop.com/library/text/template/evolicity/serialization/evolicity_cacheable_serializeable.html) for caching the substituted output. Useful for generating pages on a web-server.




## Textual Data Formats
Classes for handling various human-readable text formats. Supported formats are: XML, XHTML, HTML, JSON, CSV. (Note: Eiffel-Loop has other libraries for parsing XML)
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
## Override of EiffelVision2
Override of Eiffel Software's EiffelVision2 for use with [Eiffel-Loop Vision2 extensions](http://www.eiffel-loop.com/library/vision2-x.html)
## Override of Eiffel2Java
Override of Eiffel Software's [Eiffel2Java](https://www.eiffel.org/doc/solutions/Eiffel2Java) library for use with the [Eiffel-Loop Eiffel to Java](http://www.eiffel-loop.com/library/eiffel2java.html) library.
