note
	description: "Summary description for {M3U_PLAYLIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:04 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	M3U_PLAYLIST_READER

inherit
	LINKED_LIST [EL_PATH_STEPS]
		rename
			make as make_list,
			item as path_steps
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		undefine
			is_equal, copy
		end

	EL_MODULE_UTF
		undefine
			is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make (a_file_path: EL_FILE_PATH)
			-- Build object from xml file
		local
			lines: EL_FILE_LINE_SOURCE
		do
			make_list; make_machine

			if a_file_path.exists then
				if a_file_path.extension ~ "m3u8" then
					create {EL_UTF_8_FILE_LINES} lines.make (a_file_path)
				else
					create lines.make (a_file_path)
				end
				do_once_with_file_lines (agent find_extinf, lines)
			end
			name := a_file_path.without_extension.base
		end

feature -- Access

	name: STRING

feature {NONE} -- State line procedures

	find_extinf (line: ASTRING)
			--
		do
			if line.starts_with ("#EXTINF") then
				state := agent find_path_entry
			end
		end

	find_path_entry (line: ASTRING)
			--
		local
			l_path: EL_FILE_PATH
		do
			if not line.is_empty then
				l_path := line
				extend (l_path.steps)
				state := agent find_extinf
			end
		end

end
