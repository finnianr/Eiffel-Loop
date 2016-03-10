note
	description: "Summary description for {EL_CREATE_COMPRESSED_TAR_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:21 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_COMPRESSED_ARCHIVE_COMMAND

inherit
	EL_DOUBLE_OPERAND_FILE_SYSTEM_COMMAND [EL_COMPRESSED_ARCHIVE_IMPL]
		rename
			destination_path as archive_path,
			set_destination_path as set_archive_path
		redefine
			source_path, archive_path, make_default
		end

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create exclusion_list_path.make
			create inclusion_list_path.make
		end

feature -- Access

	archive_path: EL_FILE_PATH

	source_path: EL_DIR_PATH

	exclusion_list_path: EL_FILE_PATH

	inclusion_list_path: EL_FILE_PATH

feature -- Element change

	set_exclusion_list_path (a_exclusion_list_path: like exclusion_list_path)
		do
			exclusion_list_path := a_exclusion_list_path
		end

	set_inclusion_list_path (a_inclusion_list_path: like inclusion_list_path)
		do
			inclusion_list_path := a_inclusion_list_path
		end
end
