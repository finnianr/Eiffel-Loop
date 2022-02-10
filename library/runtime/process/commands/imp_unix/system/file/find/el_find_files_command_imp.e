note
	description: "Unix implementation of [$source EL_FIND_FILES_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-10 18:21:27 GMT (Thursday 10th February 2022)"
	revision: "9"

class
	EL_FIND_FILES_COMMAND_IMP

inherit
	EL_FIND_FILES_COMMAND_I
		export
			{NONE} all
		end

	EL_FIND_COMMAND_IMP

create
	make, make_default

feature {NONE} -- Constants

	Type: STRING = "f"
		-- Unix find type

end