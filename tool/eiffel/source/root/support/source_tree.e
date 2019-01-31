note
	description: "Source tree"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-25 17:38:25 GMT (Friday 25th January 2019)"
	revision: "8"

class
	SOURCE_TREE

inherit
	EVOLICITY_EIFFEL_CONTEXT
		undefine
			is_equal
		redefine
			make_default
		end

	COMPARABLE

	EL_MODULE_OS
		undefine
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (a_dir_path: like dir_path)
		do
			make_default
			dir_path := a_dir_path
			path_list := new_path_list
		end

	make_default
			--
		do
			create name.make_empty
			create dir_path
			Precursor {EVOLICITY_EIFFEL_CONTEXT}
		end

feature -- Access

	dir_path: EL_DIR_PATH

	name: ZSTRING

	path_list: EL_FILE_PATH_LIST

	sorted_path_list: EL_FILE_PATH_LIST
		do
			Result := path_list
			Result.sort
		end

feature -- Element change

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
			Result := Os.file_list (dir_path, "*.e")
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["name", 			agent: like name do Result := name end],
				["path_list", 		agent: like path_list do Result := path_list end]
			>>)
		end

end
