note
	description: "Windows implementation of ${EL_COPY_TREE_COMMAND_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "9"

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

create
	make, make_default

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor  + ["xcopy_destination_path", agent xcopy_destination_path]
		end

feature {NONE} -- Implementation

	xcopy_destination_path: ZSTRING
			-- Windows recursive copy
		local
			destination_dir: DIR_PATH
		do
			destination_dir := destination_path.to_string
			destination_dir.append_dir_path (source_path.base)
			Result := destination_dir.escaped
		end

feature {NONE} -- Constants

	Template: STRING = "xcopy /Q /I /E /Y $source_path $xcopy_destination_path"

end