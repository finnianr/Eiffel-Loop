note
	description: "ID3 editor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-19 9:13:21 GMT (Sunday 19th April 2020)"
	revision: "12"

class
	ID3_EDITOR

inherit
	EL_COMMAND

	EL_MODULE_USER_INPUT

	EL_MODULE_OS

	ID3_TAG_INFO_ROUTINES

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_media_dir: EL_DIR_PATH; a_edition_name: like edition_name)
		do
			edition_name := a_edition_name
			create file_paths.make (OS.file_list (a_media_dir, "*.mp3"))
			editions_table := new_editions_table
		end

feature -- Basic operations

	execute
		do
			editions_table.search (edition_name)
			if editions_table.found then
				across file_paths as mp3_path loop
					editions_table.found_item.call ([create {TL_MPEG_FILE}.make (mp3_path.item), mp3_path.item])
--					if mp3_path.cursor_index \\ 40 = 0 then
--						from until User_input.line ("Press return to continue").is_empty loop
--							lio.put_new_line
--						end
--						lio.put_new_line
--					end
				end
			else
				lio.put_string_field ("Invalid edition name", edition_name)
				lio.put_new_line
			end
		end

feature {NONE} -- Implementation

	new_editions_table: like editions_table
		do
			create Result.make (<<
				["set_fields_from_path", agent set_fields_from_path]
			>>)
		end

feature {NONE} -- Internal attributes

	editions_table: EL_ZSTRING_HASH_TABLE [PROCEDURE [TL_MPEG_FILE, EL_FILE_PATH]]

	edition_name: ZSTRING

	file_paths: EL_FILE_PATH_LIST

end
