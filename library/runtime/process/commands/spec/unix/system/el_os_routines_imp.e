note
	description: "Unix implementation of `EL_OS_ROUTINES_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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