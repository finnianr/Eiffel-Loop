note
	description: "Single thread integration of function"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-07 10:50:30 GMT (Tuesday 7th June 2022)"
	revision: "2"

class
	SINGLE_THREAD_INTEGRATION

inherit
	INTEGRATION_COMMAND

create
	make

feature -- Constants

	Description: STRING = "Single thread integration of function"

feature {NONE} -- Implementation

	calculate (lower, upper: DOUBLE)
		do
			integral_sum := integral (function, lower, upper, Option.delta_count)
		end

end