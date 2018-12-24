note
	description: "Directory list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-23 11:08:56 GMT (Sunday 23rd December 2018)"
	revision: "6"

class
	EL_DIRECTORY_LIST

inherit
	EL_ARRAYED_LIST [EL_DIRECTORY]

create
	make

feature -- Status query

	has_executable (a_name: ZSTRING): BOOLEAN
		do
			from start until Result or after loop
				Result := item.has_executable (a_name)
				forth
			end
		end

	has_file_name (a_name: ZSTRING): BOOLEAN
		do
			from start until Result or after loop
				Result := item.has_file_name (a_name)
				forth
			end
		end

end