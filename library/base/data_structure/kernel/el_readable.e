note
	description: "Abstraction for objects that have a function returning all the basic types and strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-19 12:07:34 GMT (Tuesday 19th December 2017)"
	revision: "2"

deferred class
	EL_READABLE

feature -- Integer

	read_integer_8: INTEGER_8
		deferred
		end

	read_integer_16: INTEGER_16
		deferred
		end

	read_integer_32: INTEGER_32
		deferred
		end

	read_integer_64: INTEGER_64
		deferred
		end

feature -- Natural

	read_natural_8: NATURAL_8
		deferred
		end

	read_natural_16: NATURAL_16
		deferred
		end

	read_natural_32: NATURAL_32
		deferred
		end

	read_natural_64: NATURAL_64
		deferred
		end

feature -- Real

	read_real_32: REAL_32
		deferred
		end

	read_real_64: REAL_64
		deferred
		end

feature -- String

	read_string_8: STRING_8
		deferred
		end

	read_string_32: STRING_32
		deferred
		end

	read_string: ZSTRING
		deferred
		end

feature -- Access

	read_boolean: BOOLEAN
		deferred
		end

	read_pointer: POINTER
		deferred
		end

	read_character_8: CHARACTER
		deferred
		end

	read_character_32: CHARACTER_32
		deferred
		end
end
