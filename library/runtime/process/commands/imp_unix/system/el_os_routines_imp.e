note
	description: "Unix implementation of [$source EL_OS_ROUTINES_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_OS_ROUTINES_IMP

inherit
	EL_OS_ROUTINES_I
		export
			{NONE} all
		end

	EL_OS_IMPLEMENTATION

feature {NONE} -- Factory

	new_cpu_model_name: STRING
		do
			Result := Command.new_cpu_info.model_name
		end

end
