note
	description: "Summary description for {EL_FIND_DIRECTORIES_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_FIND_DIRECTORIES_COMMAND

inherit
	EL_FIND_OS_COMMAND [EL_FIND_DIRECTORIES_IMPL, EL_DIRECTORY_PATH]
		redefine
			on_begin
		end

create
	make, make_default

feature {NONE} -- Implementation

	on_begin
			-- Prepend line to output file before command has executed
		do
			implementation.prepend_line (Current)
		end

end
