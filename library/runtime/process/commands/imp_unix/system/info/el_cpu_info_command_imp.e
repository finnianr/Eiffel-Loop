note
	description: "Unix implementation of ${EL_CPU_INFO_COMMAND_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-11 14:49:59 GMT (Thursday 11th January 2024)"
	revision: "12"

class
	EL_CPU_INFO_COMMAND_IMP

inherit
	EL_CPU_INFO_COMMAND_I
		export
			{NONE} all
		redefine
			call
		end

	EL_CAPTURED_OS_COMMAND_IMP
		rename
			do_with_lines as do_with_output_lines
		end

create
	make, make_default

feature {NONE} -- Implementation

	call (line: ZSTRING)
		-- call state procedure with item
		do
			if attached line.substring_to (Delimiter) as name then
				line.remove_head (name.count)
				name.right_adjust
				line.prepend (name)
			end
			state (line)
		end

feature {NONE} -- Constants

	Field: TUPLE [model_name, processors: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "model name, siblings")
		end

	Delimiter: CHARACTER_32 = ':'

	Template: STRING = "cat /proc/cpuinfo"

end