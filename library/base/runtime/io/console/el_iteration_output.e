note
	description: "Iteration output"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-18 13:33:54 GMT (Monday 18th January 2021)"
	revision: "6"

deferred class
	EL_ITERATION_OUTPUT

inherit
	EL_MODULE_LIO

feature -- Status change

	disable_print
		do
			is_print_progress_disabled := True
		end

feature -- Status query

	is_print_progress_disabled: BOOLEAN

feature {NONE} -- Implementation

	iterations_per_dot: NATURAL_32
		deferred
		end

	print_progress (iteration_count: NATURAL_32)
		do
			if not is_print_progress_disabled and then iteration_count \\ iterations_per_dot = 0 then
				dot_count := dot_count + 1
				lio.put_character ('.')
				if dot_count \\ Character_count = 0 then
					lio.put_new_line
				end
			end
		end

	reset
		do
			dot_count := 0
		end

feature {NONE} -- Internal attributes

	dot_count: NATURAL_32

feature {NONE} -- Constants

	Character_count: NATURAL
	 -- characters per line
		once
			Result := 100
		end

end