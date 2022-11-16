note
	description: "String iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

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