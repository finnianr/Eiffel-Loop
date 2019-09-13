note
	description: "Entry indicating location of external playlist in Pyxis format"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-12 7:48:24 GMT (Thursday 12th September 2019)"
	revision: "2"

class
	RBOX_PLAYLIST_ENTRY

inherit
	RBOX_IGNORED_ENTRY
		rename
			make as make_entry
		end

create
	make

feature {NONE} -- Initialization

	make (playlist: DJ_EVENT_PLAYLIST)
		do
			make_entry
			set_genre (Playlist_genre)
			set_title (playlist.title)
			set_media_type (Media_types.pyxis)
			set_location (playlist.output_path)
		end
end
