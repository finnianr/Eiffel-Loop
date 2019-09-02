note
	description: "Export playlists to device task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 16:28:45 GMT (Sunday 1st September 2019)"
	revision: "1"

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
		local
			device: like new_device
		do
			log.enter ("apply")
			device := new_device
			if device.volume.is_valid then
				export_to_device (device, song_in_some_playlist (Database), Database.case_insensitive_name_clashes)
			else
				notify_invalid_volume
			end
			log.exit
		end

end
