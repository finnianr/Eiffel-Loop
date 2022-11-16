note
	description: "UTF-16 sequence for single unicode character `uc'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "6"

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
				Result := (lead |<< 10) + trail - 0x35FDC00
			else
				Result := lead
			end
		end

	lead: NATURAL
		do
			Result := area [0]
		end

	trail: NATURAL
		do
			Result := area [1]
		end

	set (uc: CHARACTER_32)
		local
			c: NATURAL
		do
			c := uc.natural_32_code
			if c <= 0xFFFF then
					-- Codepoint from Basic Multilingual Plane: one 16-bit code unit.
				area [0] := c
				count := 1
			else
					-- Supplementary Planes: surrogate pair with lead and trail surrogates.
				area [0] := 0xD7C0 + (c |>> 10)
				area [1] := 0xDC00 + (c & 0x3FF)
				count := 2
			end
		ensure
			set: uc.natural_32_code = code
		end

feature -- Status query

	is_surrogate_pair: BOOLEAN
		require
			valid_count: count >= 1
		do
			Result := not (lead < 0xD800 or lead >= 0xE000)
		end
end