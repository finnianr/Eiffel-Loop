note
	description: "Unix implementation of [$source EL_SYSTEM_ROUTINES_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_SYSTEM_ROUTINES_IMP

inherit
	EL_SYSTEM_ROUTINES_I
		export
			{NONE} all
		end

	EL_OS_IMPLEMENTATION

feature {NONE} -- Factory

	new_cpu_model_name: STRING
		do
			Result := cpu_info.model_name
		end

end