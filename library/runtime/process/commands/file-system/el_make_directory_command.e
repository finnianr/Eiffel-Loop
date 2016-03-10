note
	description: "Summary description for {EL_MAKE_DIRECTORY_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-15 0:08:05 GMT (Saturday 15th June 2013)"
	revision: "2"

class
	EL_MAKE_DIRECTORY_COMMAND

inherit
	EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND [EL_MAKE_DIRECTORY_IMPL]
		rename
			path as directory_path,
			set_path as set_directory_path
		redefine
			make, getter_function_table
		end

create
	make, make_default

feature -- {}in

	make (a_directory_path: like directory_path)
			--
		require else
			is_directory: a_directory_path.is_directory
		do
			Precursor (a_directory_path)
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["directory_path", agent: EL_ASTRING do Result := escaped_path (directory_path) end]
			>>)
		end

end
