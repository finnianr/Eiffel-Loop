note
	description: "Export playlists to device task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-15 11:20:06 GMT (Wednesday 15th April 2020)"
	revision: "2"

class
	EXPORT_PLAYLISTS_TO_DEVICE_TASK

inherit
	EXPORT_MUSIC_TO_DEVICE_TASK
		redefine
			do_export
		end

create
	make

feature {NONE} -- Implementation

	do_export (device: like new_device)
		do
			if device.volume.is_valid then
				export_to_device (device, song_in_some_playlist (Database), Database.case_insensitive_name_clashes)
			else
				notify_invalid_volume
			end
		end

end
