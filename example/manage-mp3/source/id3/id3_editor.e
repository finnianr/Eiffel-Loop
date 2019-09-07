note
	description: "Id3 editor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-25 12:15:02 GMT (Friday 25th January 2019)"
	revision: "7"

class
	ID3_EDITOR

inherit
	EL_COMMAND

	EL_MODULE_LOG

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
			log.enter ("execute")
			editions_table.search (edition_name)
			if editions_table.found then
				across file_paths as mp3_path loop
					editions_table.found_item.call ([create {EL_ID3_INFO}.make_version (mp3_path.item, 2.4), mp3_path.item])
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
			log.exit
		end

feature {NONE} -- Implementation

	new_editions_table: like editions_table
		do
			create Result.make (<<
				["set_fields_from_path", agent set_fields_from_path]
			>>)
		end

feature {NONE} -- Internal attributes

	editions_table: EL_ZSTRING_HASH_TABLE [PROCEDURE [EL_ID3_INFO, EL_FILE_PATH]]

	edition_name: ZSTRING

	file_paths: EL_FILE_PATH_LIST

end
