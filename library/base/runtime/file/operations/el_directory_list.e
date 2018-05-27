note
	description: "Directory list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "4"

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