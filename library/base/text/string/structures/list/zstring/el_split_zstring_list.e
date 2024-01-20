note
	description: "[
		A list of substring index intervals conforming to ${EL_SPLIT_INTERVALS}
		for a string of type ${ZSTRING}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "24"

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
			append_z_code, item_has, proper_cased,
			separator_z_code, default_target, new_intervals, trim_string
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

	new_intervals: EL_ZSTRING_SPLIT_INTERVALS
		do
			create Result.make_empty
		end

feature {NONE} -- Implementation

	append_z_code (str: ZSTRING; z_code: NATURAL)
		do
			str.append_z_code (z_code)
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