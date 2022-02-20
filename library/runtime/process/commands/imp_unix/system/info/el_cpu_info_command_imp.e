note
	description: "Unix implementation of [$source EL_CPU_INFO_COMMAND_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-20 13:39:03 GMT (Sunday 20th February 2022)"
	revision: "8"

class
	EL_CPU_INFO_COMMAND_IMP

inherit
	EL_CPU_INFO_COMMAND_I
		export
			{NONE} all
		redefine
			call
		end

	EL_OS_COMMAND_IMP
		undefine
			do_command, new_command_parts
		end

create
	make, make_default

feature {NONE} -- Implementation

	call (line: ZSTRING)
		-- call state procedure with item
		do
			if attached line.substring_to (Delimiter, default_pointer) as name then
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