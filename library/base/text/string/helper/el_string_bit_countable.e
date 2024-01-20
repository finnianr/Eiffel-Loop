note
	description: "[
		${EL_BIT_COUNTABLE} applicable to generic class taking a string parameter conforming
		to ${READABLE_STRING_GENERAL}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "2"

deferred class
	EL_STRING_BIT_COUNTABLE [S -> READABLE_STRING_GENERAL]

inherit
	EL_BIT_COUNTABLE

feature -- Measurement

	bit_count: INTEGER
		-- number of bits
		do
			if ({S}).conforms_to ({READABLE_STRING_8}) then
				Result := 8
			else
				Result := 32
			end
		end

end