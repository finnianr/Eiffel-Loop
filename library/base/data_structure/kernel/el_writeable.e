note
	description: "Abstraction for objects that have a procedure accepting all the basic types and strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-19 12:42:47 GMT (Tuesday 19th December 2017)"
	revision: "1"

deferred class
	EL_WRITEABLE

feature -- Integer

	write_integer_8 (value: INTEGER_8)
		deferred
		end

	write_integer_16 (value: INTEGER_16)
		deferred
		end

	write_integer_32 (value: INTEGER_32)
		deferred
		end

	write_integer_64 (value: INTEGER_64)
		deferred
		end

feature -- Natural

	write_natural_8 (value: NATURAL_8)
		deferred
		end

	write_natural_16 (value: NATURAL_16)
		deferred
		end

	write_natural_32 (value: NATURAL_32)
		deferred
		end

	write_natural_64 (value: NATURAL_64)
		deferred
		end

feature -- Real

	write_real_32 (value: REAL_32)
		deferred
		end

	write_real_64 (value: REAL_64)
		deferred
		end

feature -- String

	write_raw_string_8 (value: READABLE_STRING_8)
		-- write encoded string (usually UTF-8)
		deferred
		end

	write_string_8 (value: READABLE_STRING_8)
		deferred
		end

	write_string_32 (value: READABLE_STRING_32)
		deferred
		end

	write_string (value: EL_READABLE_ZSTRING)
		deferred
		end

	write_string_general (a_string: READABLE_STRING_GENERAL)
		do
			if attached {EL_READABLE_ZSTRING} a_string as str_z then
				write_string (str_z)

			elseif attached {READABLE_STRING_8} a_string as str_8 then
				write_string_8 (str_8)

			elseif attached {READABLE_STRING_32} a_string as str_32 then
				write_string_32 (str_32)
			end
		end

feature -- Access

	write_boolean (value: BOOLEAN)
		deferred
		end

	write_pointer (value: POINTER)
		deferred
		end


	write_raw_character_8 (value: CHARACTER)
		-- write an encoding character
		deferred
		end

	write_character_8 (value: CHARACTER)
		deferred
		end

	write_character_32 (value: CHARACTER_32)
		deferred
		end

end
