note
	description: "[
		[$source EL_BIT_COUNTABLE] applicable to generic class taking a string parameter conforming
		to [$source READABLE_STRING_GENERAL]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-27 5:30:43 GMT (Thursday 27th July 2023)"
	revision: "1"

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