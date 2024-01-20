note
	description: "Unix implementation of ${EL_EXECUTABLE_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "7"

class
	EL_EXECUTABLE_IMP

inherit
	EL_EXECUTABLE_I
		export
			{NONE} all
		end

	EL_UNIX_IMPLEMENTATION

create
	make

feature {NONE} -- Implementation

	file_extensions: EL_ZSTRING_LIST
		do
			create Result.make_empty
		end

	search_path_has (a_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if executable `name' is in the environment search path `PATH'
		local
			name_path: FILE_PATH
		do
			create name_path.make (a_name)
			across search_path_list as l_path until Result loop
				name_path.set_parent (l_path.item)
				Result := name_path.exists
			end
		end

	Search_path_separator: CHARACTER_32 = ':'

end