note
	description: "[
		Descendant of ${EL_WORK_DISTRIBUTER} specialized for functions.
		`G' is the return type of functions you wish to execute. For an example on how to use see class
		${SINE_WAVE_INTEGRATION_APP}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "11"

class
	EL_FUNCTION_DISTRIBUTER [G]

inherit
	EL_WORK_DISTRIBUTER [G, FUNCTION [G]]
		rename
			valid_routine as valid_function
		end

create
	make, make_threads

feature -- Contract Support

	valid_function (function: FUNCTION [G]): BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Implementation

	new_completed (function: FUNCTION [G]): G
		do
			Result := function.last_result
		end
end