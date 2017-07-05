note
	description: "Summary description for {EL_ITERATION_OUTPUT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-07-01 14:40:11 GMT (Saturday 1st July 2017)"
	revision: "1"

deferred class
	EL_ITERATION_OUTPUT

inherit
	EL_MODULE_LIO

feature {NONE} -- Implementation

	iterations_per_dot: NATURAL_32
		deferred
		end

	print_progress (iteration_count: NATURAL_32)
		do
			if iteration_count \\ iterations_per_dot = 0 then
				dot_count := dot_count + 1
				lio.put_character ('.')
				if dot_count \\ 100 = 0 then
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

end
