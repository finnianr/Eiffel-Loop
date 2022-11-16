note
	description: "Directory list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	EL_DIRECTORY_LIST

inherit
	EL_ARRAYED_LIST [EL_DIRECTORY]

create
	make

feature -- Status query

	has_executable (a_name: ZSTRING): BOOLEAN
		do
			push_cursor
			from start until Result or after loop
				Result := item.has_executable (a_name)
				forth
			end
			pop_cursor
		end

	has_file_name (a_name: ZSTRING): BOOLEAN
		do
			push_cursor
			from start until Result or after loop
				Result := item.has_file_name (a_name)
				forth
			end
			pop_cursor
		end

end