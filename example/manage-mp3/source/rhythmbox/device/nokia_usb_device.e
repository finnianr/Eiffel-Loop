note
	description: "Nokia have their own Windows style playlist format"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NOKIA_USB_DEVICE

inherit
	USB_DEVICE
		redefine
			new_m3u_playlist
		end

create
	make

feature {NONE} -- Factory

	new_m3u_playlist (playlist: RBOX_PLAYLIST; output_path: EL_FILE_PATH): NOKIA_PLAYLIST
		do
			create Result.make (playlist.m3u_list, playlist_root, output_path)
		end

end
