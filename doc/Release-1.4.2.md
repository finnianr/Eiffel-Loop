# Eiffel-Loop as it was on the 27th July 2016

## VISION-2-X library
Changed EL_DROP_DOWN_BOX to be initialised by any finite container instead of indexable containers.

## TOOLS Eiffel-View
* It is now possible to escape square brackets so generic class can be hyper linked. For example [https://archive.eiffel.com/doc/online/eiffel50/intro/studio/index-09A/base/structures/list/chain_chart.html `CHAIN [G\]']. This prevents the right bracket in `[G]` from being interpreted as the end of hyper link text.

## BASE library
* Removed function `retrieved` from class `EL_MEMORY_READER_WRITER` used by `{EL_STORABLE}.is_reversible` and instead created `{EL_STORABLE}.read_twin`

## MP3-MANAGER example

* Added folder of example task configuration files
* Integrated DJ event playlists more tightly with Rhythmbox by locating them in `$HOME/Music/Playlists` and listing them in the database as ignored entries with genre `playlist` and media type `text/pyxis`




