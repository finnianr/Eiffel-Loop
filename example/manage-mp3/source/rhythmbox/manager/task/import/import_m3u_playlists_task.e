note
	description: "M3U playlist import task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:50 GMT (Monday 3rd January 2022)"
	revision: "5"

class
	IMPORT_M3U_PLAYLISTS_TASK

inherit
	RBOX_MANAGEMENT_TASK

	DATABASE_UPDATE_TASK

	EL_MODULE_OS

create
	make

feature -- Access

	m3u_dir: DIR_PATH
		-- Directory containing playlist to import

feature -- Basic operations

	apply
		local
			reader: M3U_PLAYLIST_READER
		do
			if m3u_dir.exists then
				across OS.file_list (m3u_dir, "*.m3u") as m3u_path loop
					create reader.make (m3u_path.item)
					lio.put_new_line
					if Database.has_playlist (reader.name) then
						lio.put_substitution ("Playlist %"%S%" already exists in database", [reader.name])

					elseif reader.missing_count > 0 then
						lio.put_substitution (
							"ERROR: Playlist %"%S%" not imported. Missing %S entries", [reader.name, reader.missing_count]
						)
					else
						Database.playlists.extend (reader.playlist)
						lio.put_string_field ("Imported playlist", reader.name)
					end
					lio.put_new_line
					lio.put_new_line
				end
				Database.playlists.store
			else
				lio.put_line ("ERROR")
				lio.put_path_field ("m3u_dir", m3u_dir)
				lio.put_line (" does not exist")
			end
		end

end
