note
	description: "[
		Abbreviate all month folder names in a directory tree and prefix with a chronological sort number.
		
		Renaming template:

			$month_number-$month_abbreviation

		Example:

			August -> 08-Aug
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-10-28 8:30:20 GMT (Tuesday 28th October 2025)"
	revision: "1"

class
	MONTH_FOLDER_SORTER

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_COMMAND; EL_MODULE_OS; EL_MODULE_LIO; EL_MODULE_FORMAT

	DATE_CONSTANTS

	EL_CHARACTER_32_CONSTANTS

	EL_SHARED_DIRECTORY

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_target_dir: DIR_PATH)
		do
			target_dir := a_target_dir
			create month_names.make (12)
			across long_months_text as list loop
				month_names.extend (list.item)
				month_names.last.to_proper
			end
		end

feature -- Basic operations

	execute
		local

		do
			across OS.directory_list (target_dir) as path loop
				check_dir (path.item)
			end
		end

feature {NONE} -- Implementation

	check_dir (a_dir_path: DIR_PATH)
		local
			month_index: INTEGER; month_code: ZSTRING
			sort_path: DIR_PATH
		do
			month_index := month_names.index_of (a_dir_path.base, 1)
			if month_index > 0 then
				month_code := months_text [month_index]; month_code.to_proper
				if attached hyphen.joined (Format.zero_padded_integer (month_index, 2), month_code) as sortable_month then
					lio.put_path_field (sortable_month, a_dir_path)
					lio.put_new_line
					sort_path := a_dir_path.twin
					sort_path.set_base (sortable_month)
					if attached Directory.named (a_dir_path) as folder then
						folder.rename_to (sort_path)
					end
				end
			end
		end

feature {NONE} -- Internal attributes

	month_names: EL_ZSTRING_LIST

	target_dir: DIR_PATH

feature {NONE} -- Constants

	Description: STRING = "[
		Abbreviate month folder names and prefix with a chronological sort number
	]"

end