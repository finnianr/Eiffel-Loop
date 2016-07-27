note
	description: "Windows implementation of `EL_COPY_TREE_COMMAND_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-17 17:52:16 GMT (Friday 17th June 2016)"
	revision: "5"

class
	EL_COPY_TREE_COMMAND_IMP

inherit
	EL_COPY_TREE_COMMAND_I
		export
			{NONE} all
		redefine
			getter_function_table
		end

	EL_OS_COMMAND_IMP
		undefine
			make_default
		redefine
			getter_function_table
		end

create
	make, make_default

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor {EL_COPY_TREE_COMMAND_I}
			Result.append_tuples (<<
				["xcopy_destination_path", 		agent xcopy_destination_path]
			>>)
		end

feature {NONE} -- Implementation

	xcopy_destination_path: ZSTRING
			-- Windows recursive copy
		local
			destination_dir: EL_DIR_PATH
		do
			destination_dir := destination_path.to_string
			destination_dir.append_dir_path (source_path.base)
			Result := escaped_path (destination_dir)
		end

feature {NONE} -- Constants

	Template: STRING = "xcopy /I /E /Y $source_path $xcopy_destination_path"

end