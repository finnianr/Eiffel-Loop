# Eiffel-Loop (1.4.2) released 10th August 2016

## VISION-2-X library
Changed EL_DROP_DOWN_BOX to be initialised by any finite container instead of an indexable container.

## TOOLS Eiffel-View publisher
* It is now possible to escape square brackets so generic class can be hyper linked. For example [`CHAIN [G]`](https://archive.eiffel.com/doc/online/eiffel50/intro/studio/index-09A/base/structures/list/chain_chart.html). This prevents the right bracket in `[G]` from being interpreted as the end of hyper link text.
* Fixed bug in note editor where classes that had notes at the bottom of page had the standard fields copied in twice.
* Fixed some problems with the output of Contents.md using Github markdown.
* Added support for ordered list items with item text rendered as `<li><span>Item text</span></li>` to allow bold numbering using CSS.

## BASE library
* Removed contract support function `{EL_MEMORY_READER_WRITER}.retrieved` used by  routine `{EL_STORABLE}.is_reversible` and instead created `{EL_STORABLE}.read_twin`
* Refactored `EL_TEXT_EDITOR` so that it doesn't inherit `EL_FILE_PARSER`. Added new classes to hierarchy: `EL_PARSER_TEXT_EDITOR`, `EL_PATTERN_SEARCHING_EIFFEL_SOURCE_EDITOR`, `EL_TEXT_FILE_EDITOR`, `EL_TEXT_FILE_CONVERTER`, `EL_FILE_PARSER_TEXT_EDITOR`
* New classes `EL_LINE_STATE_MACHINE_TEXT_FILE_EDITOR` and `EL_EIFFEL_LINE_STATE_MACHINE_TEXT_FILE_EDITOR` inheriting from `EL_TEXT_FILE_EDITOR`.
* Added function `has_step` to `EL_PATH`.

## MP3-MANAGER example

* Added folder of example task configuration files into `example/manage-mp3/doc/tasks`
* Integrated DJ event playlists more tightly with Rhythmbox by locating them in `$HOME/Music/Playlists` and listing them in the database as ignored entries with genre `playlist` and media type `text/pyxis`
* Changed archive playlist name from `Music Extra` to `Archive`




