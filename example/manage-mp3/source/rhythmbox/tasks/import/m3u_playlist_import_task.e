note
	description: "Summary description for {M3U_PLAYLIST_IMPORT_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	M3U_PLAYLIST_IMPORT_TASK

inherit
	RBOX_MANAGEMENT_TASK

	EL_MODULE_OS

create
	make

feature -- Access

	m3u_dir: EL_DIR_PATH
		-- Directory containing playlist to import

feature -- Basic operations

	apply
		local
			reader: M3U_PLAYLIST_READER
		do
			if m3u_dir.exists then
				across OS.file_list (m3u_dir, "*.m3u") as m3u_path loop
					create reader.make (m3u_path.item)
					lio.put_string_field ("Importing playlist", reader.name)
					lio.put_new_line
					Database.playlists.extend (reader.to_playlist)
					lio.put_new_line
				end
				if not is_dry_run then
					Database.playlists.store
				end
			else
				lio.put_line ("ERROR")
				lio.put_path_field ("m3u_dir", m3u_dir)
				lio.put_line (" does not exist")
			end
		end

end
