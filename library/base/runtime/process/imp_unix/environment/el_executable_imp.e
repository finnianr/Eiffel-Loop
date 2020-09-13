note
	description: "Unix implementation of [$source EL_EXECUTABLE_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-13 11:43:59 GMT (Sunday 13th September 2020)"
	revision: "1"

class
	EL_EXECUTABLE_IMP

inherit
	EL_EXECUTABLE_I
		export
			{NONE} all
		end

	EL_OS_IMPLEMENTATION

create
	make

feature {NONE} -- Implementation

	file_extensions: EL_ZSTRING_LIST
		do
			create Result.make_from_array (<< once "" >>)
		end

	Search_path_separator: CHARACTER_32 = ':'

end
