note
	description: "Nokia have their own Windows style playlist format"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

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

	new_m3u_playlist (playlist: RBOX_PLAYLIST; output_path: FILE_PATH): NOKIA_PLAYLIST
		do
			create Result.make (playlist, is_windows_format, output_path)
		end

end