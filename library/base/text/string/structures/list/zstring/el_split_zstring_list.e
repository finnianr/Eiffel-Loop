note
	description: "[
		A list of substring index intervals conforming to [$source EL_SPLIT_INTERVALS]
		for a string of type [$source ZSTRING]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-06 13:50:35 GMT (Monday 6th March 2023)"
	revision: "17"

class
	EL_SPLIT_ZSTRING_LIST

inherit
	EL_SPLIT_STRING_LIST [ZSTRING]
		rename
			append_code as append_z_code,
			separator_code as separator_z_code
		redefine
			append_z_code, fill_by_string, is_white_space, is_valid_character, proper_cased,
			separator_z_code, string_strict_cmp
		end

	EL_SHARED_ZSTRING_CODEC

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string,
	make_from_for, make_from, make_from_if

feature -- Element change

	fill_by_string (a_target: ZSTRING; a_pattern: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			set_target (a_target, a_adjustments)
			if a_pattern.count = 1 then
				fill_intervals (a_target, Empty_string_8, String_8_searcher, a_pattern [1], a_adjustments)

			elseif attached String_searcher as searcher then
				if attached a_target.z_code_pattern (a_pattern) as z_code_pattern then
					searcher.initialize_deltas (z_code_pattern)
					fill_intervals (a_target, z_code_pattern, searcher, '%U', adjustments)
				end
			end
		end

feature {NONE} -- Implementation

	append_z_code (str: ZSTRING; z_code: NATURAL)
		do
			str.append_z_code (z_code)
		end

	is_valid_character (uc: CHARACTER_32): BOOLEAN
		do
			Result := True
		end

	is_white_space (a_target: ZSTRING; i: INTEGER): BOOLEAN
		do
			Result := a_target.is_space_item (i)
		end

	proper_cased (word: ZSTRING): ZSTRING
		do
			Result := word.as_proper_case
		end

	separator_z_code (a_separator: CHARACTER_32): NATURAL
		do
			Result := codec.as_z_code (a_separator)
		end

	string_strict_cmp (left_index, right_index, n: INTEGER): INTEGER
		do
--			order `right_index', `left_index' is correct
			Result := target.order_comparison (target, right_index, left_index, n)
		end

end