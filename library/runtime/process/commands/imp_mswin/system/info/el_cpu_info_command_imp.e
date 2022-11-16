note
	description: "Windows implementation of [$source EL_CPU_INFO_COMMAND_I]"
	notes: "[
		Sample output:
		
			Name=Intel(R) Core(TM) i7-3615QM CPU @ 2.30GHz
			NumberOfLogicalProcessors=8
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "10"

class
	EL_CPU_INFO_COMMAND_IMP

inherit
	EL_CPU_INFO_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			do_command, new_command_parts
		end

create
	make, make_default

feature {NONE} -- Constants

	Delimiter: CHARACTER_32 = '='

	Field: TUPLE [model_name, processors: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "Name, NumberOfLogicalProcessors")
		end

	Template: STRING = "wmic cpu get NumberOfLogicalProcessors, Name /format:list"

end