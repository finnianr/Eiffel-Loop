note
	description: "Windows implementation of [$source EL_COPY_TREE_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
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
			Result := Precursor {EL_COPY_TREE_COMMAND_I} + ["xcopy_destination_path", agent xcopy_destination_path]
		end

feature {NONE} -- Implementation

	xcopy_destination_path: ZSTRING
			-- Windows recursive copy
		local
			destination_dir: EL_DIR_PATH
		do
			destination_dir := destination_path.to_string
			destination_dir.append_dir_path (source_path.base)
			Result := destination_dir.escaped
		end

feature {NONE} -- Constants

	Template: STRING = "xcopy /I /E /Y $source_path $xcopy_destination_path"

end
