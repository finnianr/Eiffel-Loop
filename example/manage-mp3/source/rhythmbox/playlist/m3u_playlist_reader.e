note
	description: "M3U playlist reader"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-04 18:15:33 GMT (Wednesday 4th September 2019)"
	revision: "7"

class
	M3U_PLAYLIST_READER

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_MODULE_UTF

	EL_MODULE_LIO

	SHARED_DATABASE

create
	make

feature {NONE} -- Initialization

	make (a_file_path: EL_FILE_PATH)
			-- Build object from xml file
		local
			lines: EL_PLAIN_TEXT_LINE_SOURCE
		do
			make_machine
			create path_list.make (20)

			if a_file_path.exists then
				create lines.make (a_file_path)
				do_once_with_file_lines (agent find_extinf, lines)
			end
			name := a_file_path.base_sans_extension
		end

feature -- Access

	name: ZSTRING

	to_playlist: RBOX_PLAYLIST
		local
			song_path: EL_FILE_PATH
		do
			create Result.make (name)
			across path_list as path_steps loop
				song_path := Database.music_dir + path_steps.item
				if Database.has_song (song_path) then
					Result.add_song_from_path (song_path)
					lio.put_path_field ("Imported", song_path)
				else
					lio.put_path_field ("Not found", song_path)
				end
				lio.put_new_line
			end
		end

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
			l_path: EL_FILE_PATH
		do
			if not line.is_empty then
				l_path := line
				path_list.extend (l_path.steps)
				state := agent find_extinf
			end
		end

feature {NONE} -- Internal attributes

	path_list: ARRAYED_LIST [EL_PATH_STEPS]
end
