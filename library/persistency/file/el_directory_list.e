note
	description: "Directory list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-05 18:31:49 GMT (Tuesday 5th November 2024)"
	revision: "11"

class
	EL_DIRECTORY_LIST

inherit
	EL_ARRAYED_LIST [EL_DIRECTORY]

	EL_SHARED_STRING_32_BUFFER_POOL

create
	make

feature -- Status query

	has_executable (a_name: READABLE_STRING_GENERAL): BOOLEAN
		do
			if attached String_32_pool.borrowed_item as borrowed then
--				Optimum to use {STRING_32}
				Result := there_exists (agent {EL_DIRECTORY}.has_executable (borrowed.copied_general (a_name)))
				borrowed.return
			end
		end

	has_file_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
		do
			if attached String_32_pool.borrowed_item as borrowed then
--				Optimum to use {STRING_32}
				Result := there_exists (agent {EL_DIRECTORY}.has_file_name (borrowed.copied_general (a_name)))
				borrowed.return
			end
		end

end