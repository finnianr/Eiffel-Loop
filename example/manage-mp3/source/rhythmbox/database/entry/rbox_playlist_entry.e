note
	description: "Entry indicating location of external playlist in Pyxis format"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-22 12:52:19 GMT (Friday 22nd May 2020)"
	revision: "3"

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
			set_location_uri (playlist.output_path)
		end
end
