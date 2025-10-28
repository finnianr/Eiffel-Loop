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
	date: "2025-10-28 11:55:14 GMT (Tuesday 28th October 2025)"
	revision: "2"

class
	MONTH_FOLDER_SORTER

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_COMMAND; EL_MODULE_OS; EL_MODULE_LIO; EL_MODULE_FORMAT

	DATE_CONSTANTS

	EL_CHARACTER_32_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_target_dir: DIR_PATH)
		do
			target_dir := a_target_dir
			create names_list.make (12)
			across << long_months_text, months_text >> as array loop
				across array.item as list loop
					names_list.extend (list.item)
					names_list.last.to_proper
				end
			end
		end

feature -- Basic operations

	execute
		do
			across OS.directory_list (target_dir) as path loop
				check_dir (path.item)
			end
			if not found_items then
				lio.put_line ("All month names normalized for chronological sort")
			end
		end

feature {NONE} -- Implementation

	check_dir (a_dir_path: DIR_PATH)
		local
			month_index, index: INTEGER; month_code: ZSTRING
			sort_path: DIR_PATH
		do
			month_index := names_list.index_of (a_dir_path.base, 1)
			if month_index > 0 then
				if month_index > 12 then
					month_index := month_index - 12
				end
				month_code := months_text [month_index]; month_code.to_proper
				if attached hyphen.joined (Format.zero_padded_integer (month_index, 2), month_code) as sortable_month then
					lio.put_path_field (sortable_month, a_dir_path)
					lio.put_new_line
					sort_path := a_dir_path.twin
					sort_path.set_base (sortable_month)
					OS.rename_directory (a_dir_path, sort_path)
					found_items := True
				end
			end
		end

feature {NONE} -- Internal attributes

	names_list: EL_ZSTRING_LIST
		-- long and short names list

	target_dir: DIR_PATH

	found_items: BOOLEAN

feature {NONE} -- Constants

	Description: STRING = "[
		Abbreviate month folder names and prefix with a chronological sort number
	]"

end