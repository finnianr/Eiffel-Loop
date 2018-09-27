note
	description: "Nokia have their own Windows style playlist format"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "3"

class
	NOKIA_PHONE_DEVICE

inherit
	STORAGE_DEVICE
		redefine
			new_m3u_playlist
		end

create
	make

feature {NONE} -- Factory

	new_m3u_playlist (playlist: RBOX_PLAYLIST; output_path: EL_FILE_PATH): NOKIA_PLAYLIST
		do
			create Result.make (playlist.m3u_list, playlist_root, is_windows_format, output_path)
		end

end