note
	description: "Directory list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 11:37:07 GMT (Monday 5th December 2022)"
	revision: "9"

class
	EL_DIRECTORY_LIST

inherit
	EL_ARRAYED_LIST [EL_DIRECTORY]

	EL_MODULE_REUSEABLE

create
	make

feature -- Status query

	has_executable (a_name: READABLE_STRING_GENERAL): BOOLEAN
		do
			across Reuseable.string_32 as reuse loop
--				Optimum to use {STRING_32}
				Result := there_exists (agent {EL_DIRECTORY}.has_executable (reuse.copied_item (a_name)))
			end
		end

	has_file_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
		do
			across Reuseable.string_32 as reuse loop
--				Optimum to use {STRING_32}
				Result := there_exists (agent {EL_DIRECTORY}.has_file_name (reuse.copied_item (a_name)))
			end
		end

end