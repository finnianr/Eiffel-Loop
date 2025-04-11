note
	description: "[
		A list of substring index intervals conforming to ${EL_SPLIT_INTERVALS}
		for a string of type ${ZSTRING}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-11 15:02:55 GMT (Friday 11th April 2025)"
	revision: "29"

class
	EL_SPLIT_ZSTRING_LIST

inherit
	EL_SPLIT_STRING_LIST [ZSTRING]
		rename
			append_code as append_z_code,
			separator_code as separator_z_code
		undefine
			bit_count
		redefine
			append_z_code, extended_string, item_has, proper_cased,
			separator_z_code, default_target, fill_intervals_by_string, trim_string
		end

	EL_STRING_32_BIT_COUNTABLE [ZSTRING]

	EL_ZSTRING_CONSTANTS

	EL_SHARED_ZSTRING_CODEC

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string,
	make_from_for, make_from, make_from_if

feature -- Status query

	item_has (uc: CHARACTER_32): BOOLEAN
		local
			i: INTEGER
		do
			i := (index - 1) * 2
			if attached area as a then
				Result := target_string.has_between (uc, a [i], a [i + 1])
			end
		end

feature -- Element change

	trim_string
		do
			target_string.trim
		end

feature {NONE} -- Implementation

	default_target: ZSTRING
		do
			Result := Empty_string
		end

	fill_intervals_by_string (a_target: ZSTRING; delimiter: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			area_intervals.fill_by_string (a_target, delimiter, a_adjustments)
			area := area_intervals.area
		end

feature {NONE} -- Implementation

	append_z_code (str: ZSTRING; z_code: NATURAL)
		do
			str.append_z_code (z_code)
		end

	extended_string (str: ZSTRING): like super_z
		do
			Result := super_z (str)
		end

	proper_cased (word: ZSTRING): ZSTRING
		do
			Result := word.as_proper_case
		end

	separator_z_code (a_separator: CHARACTER_32): NATURAL
		do
			Result := codec.as_z_code (a_separator)
		end

end