note
	description: "Table of ISE class links from eiffel.org"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-03 13:44:49 GMT (Wednesday 3rd March 2021)"
	revision: "1"

class
	ISE_CLASS_CHART_TABLE

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

	make (a_ise_chart_template: ZSTRING)
		require
			enough_holders: a_ise_chart_template.occurrences ('%S') = 2
		do
			make_solitary
			make_equal (50)
			ise_chart_template := a_ise_chart_template
			ise_library_path := "$ISE_EIFFEL/library"
			ise_library_path.expand
			create last_name.make_empty
		end

feature -- Access

	last_name: ZSTRING

feature -- Status query

	has_class (text: ZSTRING): BOOLEAN
		local
			file_name: ZSTRING path_steps: EL_PATH_STEPS; eiffel: EL_EIFFEL_SOURCE_ROUTINES
		do
			if text.is_empty then
				last_name.wipe_out

			elseif attached Find_ise_class as finder then
				last_name := eiffel.parsed_class_name (text)
				if not has_key (last_name) then
					file_name := last_name.as_lower + Dot_e
					finder.set_dir_path (ise_library_path)
					finder.set_file_pattern (file_name)
					finder.execute
					if finder.path_list.count > 0 then
						path_steps := finder.path_list.first.relative_path (ise_library_path)
						put (ise_chart_template #$ [path_steps.first, last_name.as_lower], last_name)
					else
						create found_item.make_empty
					end
				end
			end
		end

feature {NONE} -- Initialization

	ise_chart_template: ZSTRING

	ise_library_path: EL_DIR_PATH

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