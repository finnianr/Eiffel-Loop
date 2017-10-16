note
	description: "Nokia have their own Windows style playlist format"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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