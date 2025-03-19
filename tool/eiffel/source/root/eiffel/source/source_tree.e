note
	description: "Source tree"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:00:34 GMT (Tuesday 18th March 2025)"
	revision: "22"

class
	SOURCE_TREE

inherit
	EVC_EIFFEL_CONTEXT
		undefine
			is_equal
		redefine
			make_default
		end

	COMPARABLE

	EL_MODULE_OS

create
	make

feature {NONE} -- Initialization

	make (a_dir_path: like dir_path)
		do
			make_default
			dir_path := a_dir_path
		end

	make_default
			--
		do
			create name.make_empty
			create dir_path
			create path_list.make_empty
			Precursor {EVC_EIFFEL_CONTEXT}
		end

feature -- Access

	dir_path: DIR_PATH

	file_count: INTEGER
		do
			Result := path_list.count
		end

	name: ZSTRING

	path_list: EL_FILE_PATH_LIST

	sorted_path_list: EL_FILE_PATH_LIST
		do
			Result := path_list
			Result.ascending_sort
		end

feature -- Element change

	read_file_list
		do
			path_list := new_path_list
		end

	set_name (a_name: like name)
		do
			name := a_name
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			Result := name < other.name
		end

feature {NONE} -- Implementation

	new_path_list: EL_FILE_PATH_LIST
		do
			if dir_path.exists then
				Result := OS.file_list (dir_path, "*.e")
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["name",			agent: like name do Result := name end],
				["path_list", 	agent: like path_list do Result := path_list end]
			>>)
		end

end