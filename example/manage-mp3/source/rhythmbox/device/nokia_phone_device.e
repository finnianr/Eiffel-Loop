note
	description: "Nokia have their own Windows style playlist format"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-03 12:55:14 GMT (Tuesday 3rd September 2019)"
	revision: "4"

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
			create Result.make (playlist, is_windows_format, output_path)
		end

end
