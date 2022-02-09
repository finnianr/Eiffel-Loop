note
	description: "Single thread integration of function"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-09 0:01:56 GMT (Wednesday 9th February 2022)"
	revision: "1"

class
	SINGLE_THREAD_INTEGRATION

inherit
	INTEGRATION_COMMAND

create
	make

feature -- Constants

	Description: STRING = "Single thread integration of function"

feature {NONE} -- Implementation

	integral_sum (lower, upper: DOUBLE): DOUBLE
		do
			Result := integral (function, lower, upper, Option.delta_count)
		end

end