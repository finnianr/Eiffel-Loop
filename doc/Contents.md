# Eiffel-Loop Contents
## Submission for 99-bottles-of-beer.net
Eiffel submission for [www.99-bottles-of-beer.net](http://www.99-bottles-of-beer.net/).

This website contains sample programs for over 1500 languages and variations, all of which print the lyrics of the song "99 Bottles of Beer".
## Eiffel remote object test server (EROS)
Example program demonstrating the use of the EROS library. EROS is an acronym for **E**iffel **R**emote **O**bject **S**erver. It uses an XML remote procedure call protocol.
## EROS test clients
Example program demonstrating how a client can call a server created with the EROS library. EROS is an acronym for **E**iffel **R**emote **O**bject **S**erver. It uses an XML remote procedure call protocol.
## Eiffel to Java
Demonstration program for the Eiffel-Loop Java interface library. This library provides a useful layer of abstraction over the Eiffel Software JNI interface.
## Rhythmbox MP3 Collection Manager
This is a full-blown MP3 collection manager that is designed to work in conjunction with the Rhythmbox media player.


## Vision-2 Extensions Demo

## Development Toolkit Program

## Development Testing

## Audio Processing Classes

## Base Data Structures

## Base Math Classes

## Base Persistency Classes

## Base Runtime Classes

## Base Text Processing Classes

## Base Miscellaneous Utility Classes

## Graphical Image Utilities

## HTML Viewer (based on Vision-2)

## Vision-2 GUI Extensions

## Windows Eiffel Library Extensions

## Interface to C/C++ and MS COM objects

## Interface to Java
A high-level framework for wrapping Java classes that adds a useful layer of abstraction to Eiffel Software's  interface to the JNI ([Java Native Interface](https://en.wikipedia.org/wiki/Java_Native_Interface)) called [eiffel2java](https://www.eiffel.org/doc/solutions/Eiffel2Java).

**Features**
* Better Java environment discovery for initialization.
* Automates composition of JNI call signature strings.
* Automates cleanup of Java objects.

The framework is based on the concept of a Java agent that is similar to an Eiffel agent. You will find classes: [`JAVA_FUNCTION`](http://www.eiffel-loop.com/library/language_interface/Java/java_agents/java_static_function.html) and  [`JAVA_PROCEDURE`](http://www.eiffel-loop.com/library/language_interface/Java/java_agents/java_procedure.html) that inherit [`JAVA_ROUTINE`](http://www.eiffel-loop.com/library/language_interface/Java/java_agents/java_routine.html). These agent classes automatically generate correct JNI call signatures. The library allows the creation of recursively wrapped classes where the arguments and return types to wrapped routines are themselves wrapped classes.

[See here](http://www.eiffel-loop.com/example/eiffel2java/source/class-index.html) for an example of it's use.


## Interface to Matlab
**Status:** No longer maintained

[Matlab](http://uk.mathworks.com/products/matlab/) is a popular math orientated scripting language. This interface was developed with Matlab Version 6.5, VC++ 8.0 Express Edition and Windows XP SP2.
## Interface to Praat-script
**Status:** No longer maintained

[Praat](http://www.fon.hum.uva.nl/praat) is a free tool for doing acoustic and phonetic analysis and has it's own scripting language, Praat-script.

The `el_toolkit` utility has an option for converting the source code of Praat ver. 4.4 to compile with MSC. (Praat compiles "out of the box" with the mingw compiler, but at the time EiffelStudio didn't support mingw)

Developed with VC++ 8.0 Express Edition, Windows XP SP2, Praat source code version 4.4.30. The conversion tool will not work with later versions of Praat.


## Interface to Python

## Basic Networking Classes

## Adobe Flash interface for Laabhair
**Status:** No longer maintained

Eiffel interface to [Flash ActionScript objects](https://github.com/finnianr/Eiffel-Loop/blob/master/Flash_library/eiffel_loop/laabhair) used in the **Laabhair** digital signal processing framework. This framework allows you to create applications that process speech with a [Praat](http://www.fon.hum.uva.nl/praat) script in real time and create visual representations of the the data in Flash. Depends on the Eiffel-Loop Praat-script interface library.

Developed on Windows XP SP2 with Flash Professional 8 IDE, EiffelStudio 6.1,  VC++ 8.0 Express Edition.

Laabhair was developed at the [Digital Media Centre at the Dublin Institute of Technology](http://dmc.dit.ie/)




## Eiffel Remote Object Server (EROS)

## Transfer Protocols

## Interface to Paypal API (HTTP NVP)

## Goanna Servlet Extensions

## Eiffel CHAIN Orientated Binary Database
Implements "in-memory" database tables based on an interface defined by the kernel Eiffel class [`CHAIN`](https://archive.eiffel.com/doc/online/eiffel50/intro/studio/index-09A/base/structures/list/chain_chart.html). There are two main table types:

**1.** Monolithic tables which can only be saved to disk as a whole and any new items which have not been saved will be lost.

**2.** Transactional tables where the effects of the table item operations: *extend, replace or delete*,  are immediately committed to disk in an editions table file. When the editions file gets too large, the editions are consolidated into the main table file.

Monolithic tables are implemented by class:

[`EL_STORABLE_CHAIN`](http://www.eiffel-loop.com/library/persistency/database/binary-db/el_storable_chain.html) `[G ->` [`EL_STORABLE`](http://www.eiffel-loop.com/library/base/utility/memory/el_storable.html) `create make_default end]`

This class defines the basic database *CRUD* concept of **C**reate, **R**ead, **U**pdate and **D**elete:

**Create:** is implemented by the `{EL_STORABLE_CHAIN}.extend` procedure.

**Read:** is implemented by the `{EL_STORABLE_CHAIN}.item` function.

**Update:** is implemented by the `{EL_STORABLE_CHAIN}.replace` procedure.

**Delete:** is implemented by the `{EL_STORABLE}.delete` procedure.

Transactional tables are implemented using the [`EL_RECOVERABLE_STORABLE_CHAIN`](http://www.eiffel-loop.com/library/persistency/database/binary-db/el_recoverable_storable_chain.html) class which inherits `EL_STORABLE_CHAIN`. It is called 'recoverable' because if the power suddenly goes off on your PC, the table is fully recoverable from the editions file. 

**ENCRYPTION**

AES encryption is supported for both monolithic and transactional tables.

**RELATIONAL CAPABILITIES**

Some experimental relational capabilities have been added in a private project but these classes have not yet found their way into Eiffel-Loop.

**EXAMPLES** Unfortunately the only examples are in a private commercial project. But if there is enough popular demand, the author will open source some of them.


## Search Engine Classes

## Windows Registry Access
This library adds a layer of abstraction to the Windows registry classes found the in the [Eiffel Windows Library WEL](https://www.eiffel.org/resources/libraries/wel). This abstraction layer makes it much easier and more intuitive to search, read and edit Windows registry  keys and data. See [this article](https://room.eiffel.com/article/windows_registry_access_made_easy) on Eiffel room.


## Eiffel CHAIN-based XML Database

## XML and Pyxis Document Scanning and Object Building (eXpat)
Classes for scanning XML and [Pyxis](https://room.eiffel.com/node/527) documents using a common interface. Pyxis is a more readable XML equivalent that resembles Python code.

This interface also includes a way of building Eiffel objects from element contexts defined by relative Xpaths. Although this is only a very partial implementation of Xpath, it is still very useful.

The XML implementation is based on a modified GOBO wrapper for the [eXpat XML parser](http://expat.sourceforge.net/) (written in C). The Pyxis implementation is pure Eiffel.


## XML Document Scanning and Object Building (VTD-XML)
Classes for scanning XML documents and building Eiffel objects from XML contexts defined by relative Xpaths. Based on the [VTD-XML parser](http://vtd-xml.sourceforge.net/). This is a full implemenation of Xpath 1.0.

VTD-XML uses a very fast and efficient method of building a compressed representation of an XML object using [virtual token descriptors](http://vtd-xml.sourceforge.net/VTD.html).

Using the Eiffel API is considerably easier and more intuitive to use than the original Java or C version of VTD-XML.

A substantial C-bridge was developed to make Eiffel work better with VTD-XML. The original VTX-XML code was forked to make it possible to compile it with the MSC compiler. This fork is found under `contrib/C`.


## OpenOffice Spreadsheet
Classes for parsing [OpenDocument Flat XML spreadsheets](http://www.datypic.com/sc/odf/e-office_spreadsheet.html) using [VTD-XML](http://vtd-xml.sourceforge.net/).
## Multi-application Management
**Introduction** This library accomplishes two goals:

**1.** Manage a collection of small (and possibility related) "mini-applications" as a single Eiffel application.

**2.** Implement the concept of a self-installing/uninstalling application on multiple-platforms.

**"Swiss-army-knife applications"** Creating a new project application in Eiffel is expensive both in terms of time to create a new ECF and project directory structure, and in terms of diskspace. If all you want to do is create a small utility to do some relatively minor task, it makes sense to include it with a other such utilities in a single application. But you need some framework to manage all these sub-applications. In this package, the two classes [`EL_MULTI_APPLICATION_ROOT`](http://www.eiffel-loop.com/library/runtime/app-manage/el_multi_application_root.html) and [`EL_SUB_APPLICATION`](http://www.eiffel-loop.com/library/runtime/app-manage/sub-app/el_sub_application.html) provide this capability.

**Command line sub-applications** The following features exist for creating command line applications:


* The class [`EL_COMMAND_LINE_SUB_APPLICATION`](http://www.eiffel-loop.com/library/runtime/app-manage/sub-app/el_command_line_sub_application.html) provides a smart way of mapping command line arguments to the arguments of a creation procedure with automatic string conversion according to type.
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

**Resource Management** The library provides a system of managing application resources like graphics, help files etc.




## Eiffel Thread Extensions

## Multi-threaded Logging

## OS Command Wrapping

## Development Testing Classes

## AES Encryption Extensions
Extensions to Colin LeMahieu's [AES encryption library](https://github.com/EiffelSoftware/EiffelStudio/tree/master/Src/contrib/library/text/encryption/eel). Includes a class for reading and writing encrypted files using [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) cipher [block chains](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation).
## RSA Public-key Encryption Extensions
Extends Colin LeMahieu's arbitrary precision integer library to conform to some RSA standards. The most important is the ability to read key-pairs conforming to the X509 PKCS1 standard. The top level class to access these facilities is `[EL_MODULE_X509_COMMAND](http://www.eiffel-loop.com/library/text/encryption/rsa/x509/el_module_x509_command.html)`.

The private key reader however uses a non-standard encryption scheme. It assumes the file is encrypted using the Eiffel-Loop utility contained in `el_toolkit`. See class [`CRYPTO_APP`](http://www.eiffel-loop.com/tool/toolkit/source/applications/crypto_app.html) for details.






## Internationalization

## Evolicity Text Substitution Engine
**Evolicity** is a text substitution language that was inspired by the [Velocity text substitution language](http://velocity.apache.org/) for Java. *Evolicity* provides a way to merge the data from Eiffel objects into a text template. The template can be either supplied externally or hard-coded into an Eiffel class. The language includes, substitution variables, conditional statements and loops. Substitution variables have a BASH like syntax. Conditionals and loops have an Eiffel like syntax.

The text of this web page was generated using an *Evolicity* template which you can see here: [https://github.com/finnianr/Eiffel-Loop/blob/master/doc-config/source-code.html.evol](https://github.com/finnianr/Eiffel-Loop/blob/master/doc-config/source-code.html.evol)

To make an Eiffel class serializable with *Evolicity* you inherit from class [`EVOLICITY_SERIALIZEABLE`](http://www.eiffel-loop.com/library/text/template/evolicity/serialization/evolicity_serializeable.html). Read the class notes for details on how to use. You can also access the substitution engine directly from the shared instance in class [`EL_MODULE_EVOLICITY_TEMPLATES`](http://www.eiffel-loop.com/library/text/template/evolicity/el_module_evolicity_templates.html)

**Features**


* Templates are compiled to an intermediate byte code stored in `.evc` files. This saves time consuming lexing operations on large templates.
* Has a class [`EVOLICITY_CACHEABLE_SERIALIZEABLE`](http://www.eiffel-loop.com/library/text/template/evolicity/serialization/evolicity_cacheable_serializeable.html) for caching the substituted output. Useful for generating pages on a web-server.




## Application License Management
This contains a few basic classes for constructing an application license manager. The most important is a way to obtain a unique machine ID using a combination of the CPU model name and MAC address either from the network card or wifi card. 

The principle developer of Eiffel-loop has developed a sophisticated license management system using RSA public key cryptography, however it is not available as open source. If you are interested to license this system for your company, please contact the developer. It has been used for the [My Ching](http://myching.software) software product.


## Performance Benchmarking and Command Shell

## ZLib Compression

## Override of ES GUI Toolkits

## Override of ES Eiffel to Java Interface

