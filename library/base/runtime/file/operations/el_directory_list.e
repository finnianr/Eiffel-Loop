note
	description: "Summary description for {EL_DIRECTORY_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-23 19:55:14 GMT (Thursday 23rd June 2016)"
	revision: "1"

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