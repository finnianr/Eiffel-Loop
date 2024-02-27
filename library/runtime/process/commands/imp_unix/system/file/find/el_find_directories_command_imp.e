note
	description: "Unix implementation of ${EL_FIND_DIRECTORIES_COMMAND_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-27 12:09:03 GMT (Tuesday 27th February 2024)"
	revision: "13"

class
	EL_FIND_DIRECTORIES_COMMAND_IMP

inherit
	EL_FIND_DIRECTORIES_COMMAND_I
		export
			{NONE} all
		redefine
			on_error
		end

	EL_FIND_COMMAND_IMP
		redefine
			on_error
		end

create
	make, make_default

feature {NONE} -- Implementation

	on_error (error: EL_ERROR_DESCRIPTION)
		do
			if error.line_count = 1 and then error.first_line.has_substring ("Permission denied") then
			-- We don't want command to fail just because one directory is denying permission
			-- find: /usr/share/doc/google-chrome-stable: Permission denied
				has_error := False
			end
		end

feature {NONE} -- Constants

	Type: STRING = "d"
		-- Unix find type

end