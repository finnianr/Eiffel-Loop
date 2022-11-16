note
	description: "Single thread integration of function"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "3"

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