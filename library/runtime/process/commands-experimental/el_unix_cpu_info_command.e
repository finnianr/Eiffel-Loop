note
	description: "Summary description for {EL_CPU_INFO_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

class
	EL_UNIX_CPU_INFO_COMMAND

inherit
	EL_OS_COMMAND [EL_UNIX_CPU_INFO_COMMAND_IMPL]
		export
			{NONE} all
		redefine
			make, do_with_line
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			create model_name.make_empty
			execute
		end

feature -- Access

	model_name: STRING

feature {NONE} -- Implementation

	do_with_line (line: STRING)
			--
		do
			if line.starts_with ("model name") then
				model_name := line.substring (line.index_of (':', 1) + 2, line.count)
			end
		end

end
