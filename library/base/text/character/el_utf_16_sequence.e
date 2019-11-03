note
	description: "UTF-16 sequence for single unicode character `uc'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-28 11:23:18 GMT (Monday 28th October 2019)"
	revision: "4"

class
	EL_UTF_16_SEQUENCE

inherit
	EL_UTF_SEQUENCE

create
	make

feature {NONE} -- Initialization

	make
		do
			make_filled_area (0, 2)
		end

feature -- Access

	character_32: CHARACTER_32
		do
			Result := code.to_character_32
		end

	code: NATURAL
		require
			valid_count: count >= 1 and then count = 2 implies is_surrogate_pair
		do
			if count = 2 then
				Result := (first |<< 10) + area [1] - 0x35FDC00
			else
				Result := first
			end
		end

	first: NATURAL
		do
			Result := area [0]
		end

feature -- Status query

	is_surrogate_pair: BOOLEAN
		require
			valid_count: count >= 1
		do
			Result := not (first < 0xD800 or first >= 0xE000)
		end
end
