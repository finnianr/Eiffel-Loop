note
	description: "Directory list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 13:42:33 GMT (Wednesday 8th November 2023)"
	revision: "10"

class
	EL_DIRECTORY_LIST

inherit
	EL_ARRAYED_LIST [EL_DIRECTORY]

	EL_SHARED_STRING_32_BUFFER_SCOPES

create
	make

feature -- Status query

	has_executable (a_name: READABLE_STRING_GENERAL): BOOLEAN
		do
			across String_32_scope as scope loop
--				Optimum to use {STRING_32}
				Result := there_exists (agent {EL_DIRECTORY}.has_executable (scope.copied_item (a_name)))
			end
		end

	has_file_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
		do
			across String_32_scope as scope loop
--				Optimum to use {STRING_32}
				Result := there_exists (agent {EL_DIRECTORY}.has_file_name (scope.copied_item (a_name)))
			end
		end

end