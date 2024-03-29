note
	description: "M3U playlist reader"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-09 9:55:20 GMT (Monday 9th January 2023)"
	revision: "21"

class
	M3U_PLAYLIST_READER

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_MODULE_LIO

	SHARED_DATABASE

create
	make

feature {NONE} -- Initialization

	make (a_file_path: FILE_PATH)
			-- Build object from xml file
		do
			make_machine
			name := a_file_path.base_name
			create playlist.make (a_file_path.base_name)

			if a_file_path.exists then
				do_once_with_file_lines (agent find_extinf, open_lines (a_file_path, Utf_8))
			end
		end

feature -- Access

	name: ZSTRING

	playlist: RBOX_PLAYLIST

	missing_count: INTEGER

feature {NONE} -- State line procedures

	find_extinf (line: ZSTRING)
			--
		do
			if line.starts_with_general ("#EXTINF") then
				state := agent find_path_entry
			end
		end

	find_path_entry (line: ZSTRING)
			--
		local
			song_uri: EL_URI; relative_path, song_path: FILE_PATH
		do
			if not line.is_empty then
				relative_path := line
				if attached relative_path.steps as steps then
					steps.remove_head (steps.index_of (Music, 1))
					relative_path := steps
				end
				song_path := Database.music_dir + relative_path
				song_uri := song_path
				if Database.has_song (song_uri) then
					playlist.add_song_from_path (song_uri)
					lio.put_path_field ("Found %S", relative_path)
				else
					lio.put_path_field ("%S not found", relative_path)
					missing_count := missing_count + 1
				end
				lio.put_new_line
				state := agent find_extinf
			end
		end

feature {NONE} -- Constants

	Music: ZSTRING
		once
			Result := "Music"
		end
end