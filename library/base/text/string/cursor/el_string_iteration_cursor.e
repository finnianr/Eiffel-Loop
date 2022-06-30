note
	description: "String iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-29 15:55:14 GMT (Wednesday 29th June 2022)"
	revision: "1"

deferred class
	EL_STRING_ITERATION_CURSOR

feature -- Status query

	all_ascii: BOOLEAN
		deferred
		end

feature -- Measurement

	latin_1_count: INTEGER
		deferred
		end

	leading_occurrences (uc: CHARACTER_32): INTEGER
		deferred
		end

	leading_white_count: INTEGER
		deferred
		end

	trailing_white_count: INTEGER
		deferred
		end

end