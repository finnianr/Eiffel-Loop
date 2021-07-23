note
	description: "Table of ISE class links from eiffel.org and github.com/EiffelSoftware"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-22 14:02:55 GMT (Thursday 22nd July 2021)"
	revision: "4"

class
	ISE_CLASS_TABLE

inherit
	EL_ZSTRING_HASH_TABLE [ZSTRING]
		rename
			make as table_make
		export
			{NONE} all
			{ANY} found_item
		end

	EL_SOLITARY
		rename
			make as make_solitary
		end

create
	make

feature {NONE} -- Initialization

	make (a_ise_chart_template, a_github_base: ZSTRING)
		require
			enough_holders: a_ise_chart_template.occurrences ('%S') = 2
		local
			dir_path: EL_DIR_PATH
		do
			make_solitary
			make_equal (50)
			ise_chart_template := a_ise_chart_template; github_base := a_github_base
			across << "library", "contrib" >> as dir loop
				create dir_path.make ("$ISE_EIFFEL/" + dir.item)
				dir_path.expand
				if dir.cursor_index = 1 then
					ise_library_path := dir_path
				else
					ise_contrib_path := dir_path
				end
			end
			ise_directories := << ise_library_path, ise_contrib_path >>
			create last_name.make_empty
		end

feature -- Access

	last_name: ZSTRING

feature -- Status query

	has_class (text: ZSTRING): BOOLEAN
		local
			file_name: ZSTRING; eiffel: EL_EIFFEL_SOURCE_ROUTINES
			relative_source_path: EL_FILE_PATH
		do
			if text.is_empty then
				last_name.wipe_out

			elseif attached Find_ise_class as finder then
				last_name := eiffel.parsed_class_name (text)
				if has_key (last_name) then
					Result := True
				else
					file_name := last_name.as_lower + Dot_e
					across ise_directories as dir_path until Result loop
						finder.set_dir_path (dir_path.item)
						finder.set_name_pattern (file_name)
						finder.execute
						if finder.path_list.count > 0 then
							relative_source_path := finder.path_list.first_path.relative_path (dir_path.item)
							if dir_path.item = ise_library_path then
								put (ise_chart_template #$ [relative_source_path.first_step, last_name.as_lower], last_name)
							else
								put (github_base + relative_source_path.to_string, last_name)
							end
							Result := True
						else
							create found_item.make_empty
						end
					end
				end
			end
		end

feature {NONE} -- Initialization

	ise_chart_template: ZSTRING

	github_base: ZSTRING

	ise_library_path: EL_DIR_PATH

	ise_contrib_path: EL_DIR_PATH

	ise_directories: ARRAY [EL_DIR_PATH]

feature {NONE} -- Constants

	Dot_e: ZSTRING
		once
			Result := ".e"
		end

	Find_ise_class: EL_FIND_FILES_COMMAND_I
		once
			create {EL_FIND_FILES_COMMAND_IMP} Result.make_default
		end

end