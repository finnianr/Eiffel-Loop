note
	description: "Table of ISE class links from eiffel.org and github.com/EiffelSoftware"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 12:55:11 GMT (Saturday 20th January 2024)"
	revision: "8"

class
	ISE_CLASS_TABLE

inherit
	EL_ZSTRING_HASH_TABLE [EL_FILE_URI_PATH]
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
			dir_path: DIR_PATH
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
		end

feature -- Status query

	has_class (name: ZSTRING): BOOLEAN
		require
			not_empty: name.count > 0
		local
			file_name: ZSTRING; relative_source_path: FILE_PATH
		do
			if has_key (name) then
				Result := True

			elseif attached Find_ise_class as finder then
				file_name := name + Dot_e
				file_name.to_lower

				across ise_directories as dir_path until Result loop
					finder.set_dir_path (dir_path.item)
					finder.set_name_pattern (file_name)
					finder.execute
					if finder.path_list.count > 0 then
						relative_source_path := finder.path_list.first_path.relative_path (dir_path.item)
					-- Need to put `name.twin' as `name' might be a shared buffer string
						if dir_path.item = ise_library_path then
							put (ise_chart_template #$ [relative_source_path.first_step, name.as_lower], name.twin)
						else
							put (github_base + relative_source_path.to_string, name.twin)
						end
						Result := True
					else
						create found_item
					end
				end
			end
		end

feature {NONE} -- Initialization

	ise_chart_template: ZSTRING

	github_base: ZSTRING

	ise_library_path: DIR_PATH

	ise_contrib_path: DIR_PATH

	ise_directories: ARRAY [DIR_PATH]

feature {NONE} -- Constants

	Dot_e: STRING = ".e"

	Find_ise_class: EL_FIND_FILES_COMMAND_I
		once
			create {EL_FIND_FILES_COMMAND_IMP} Result.make_default
		end

end