note
	description: "[
		Interface to classes [$source EL_STRING_8_ITERATION_CURSOR] and [$source EL_STRING_32_ITERATION_CURSOR]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-27 14:33:08 GMT (Sunday 27th August 2023)"
	revision: "11"

deferred class
	EL_STRING_ITERATION_CURSOR

inherit
	EL_ZCODE_CONVERSION

	EL_SHARED_ZSTRING_CODEC

	STRING_HANDLER

	EL_BIT_COUNTABLE

feature {NONE} -- Initialization

	make (t: like target)
		deferred
		end

	make_empty
		do
			make (empty_target)
		end

feature -- Basic operations

	append_to (destination: SPECIAL [CHARACTER_32]; source_index, n: INTEGER)
		require
			enough_space: n <= destination.capacity - destination.count
		deferred
		end

	fill_z_codes (destination: SPECIAL [CHARACTER_32])
		-- fill destination with z_codes
		require
			valid_size: destination.count >= target_count + 1
		local
			i, i_final: INTEGER; code: NATURAL
		do
			if attached area as l_area and then attached codec as l_codec then
				i_final := target_count
				from i := 0 until i = i_final loop
					code := l_codec.as_z_code (i_th_character_32 (l_area, i + area_first_index))
					destination [i] := code.to_character_32
					i := i + 1
				end
				destination [i] := '%U'
			end
		end

	parse (convertor: STRING_TO_NUMERIC_CONVERTOR; type: INTEGER)
		deferred
		end

feature -- Status query

	all_ascii: BOOLEAN
		deferred
		end

	has_character_in_bounds (uc: CHARACTER_32; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if `uc' occurrs between `start_index' and `end_index'
		require
			valid_start_index: valid_index (start_index)
			valid_end_index: end_index >= start_index and end_index <= target_count
		deferred
		end

	is_eiffel: BOOLEAN
		-- `True' if `target' is an Eiffel identifier
		do
			Result := is_area_eiffel_identifier ({EL_CASE}.Lower | {EL_CASE}.Upper)
		end

	is_eiffel_lower: BOOLEAN
		-- `True' if `target' is a lower-case Eiffel identifier
		do
			Result := is_area_eiffel_identifier ({EL_CASE}.Lower)
		end

	is_eiffel_title: BOOLEAN
		-- `True' if `target' is an title-case Eiffel identifier
		do
			Result := is_area_eiffel_identifier ({EL_CASE}.Title | {EL_CASE}.Lower)
		end

	is_eiffel_upper: BOOLEAN
		-- `True' if `target' is an upper-case Eiffel identifier
		do
			Result := is_area_eiffel_identifier ({EL_CASE}.Upper)
		end

	valid_index (i: INTEGER): BOOLEAN
		do
			Result := target.valid_index (i)
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

	target_count: INTEGER
		deferred
		end

	trailing_white_count: INTEGER
		deferred
		end

feature {NONE} -- Implementation

	is_area_eiffel_identifier (case_code: NATURAL): BOOLEAN
		local
			first_i: BOOLEAN; i, last_i: INTEGER; l_area: like area
		do
			last_i := area_last_index; l_area := area
			Result := target_count > 0; first_i := True
			from i := area_first_index until i > last_i or not Result loop
				Result := is_i_th_eiffel_identifier (l_area, i, case_code, first_i)
				if first_i then
					first_i := False
				end
				i := i + 1
			end
		end

feature {STRING_HANDLER} -- Deferred

	area: SPECIAL [ANY]
		deferred
		end

	area_first_index: INTEGER
		deferred
		end

	area_last_index: INTEGER
		deferred
		end

	empty_target: like target
		deferred
		end

	i_th_character_32 (a_area: like area; i: INTEGER): CHARACTER_32
		deferred
		end

	is_i_th_eiffel_identifier (a_area: like area; i: INTEGER; case_code: NATURAL; first_i: BOOLEAN): BOOLEAN
		deferred
		end

	target: READABLE_STRING_GENERAL
		deferred
		end

end