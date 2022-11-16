note
	description: "Export playlists to device task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "4"

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