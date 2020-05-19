note
	description: "Export playlists to device task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-19 17:36:18 GMT (Tuesday 19th May 2020)"
	revision: "3"

class
	EXPORT_PLAYLISTS_TO_DEVICE_TASK

inherit
	EXPORT_MUSIC_TO_DEVICE_TASK
		redefine
			apply
		end

create
	make

feature -- Basic operations

	apply
		do
			export_to_device (song_in_some_playlist (Database), Database.case_insensitive_name_clashes)
		end

end
