note
	description: "String 32 routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-06 11:38:36 GMT (Wednesday 6th January 2021)"
	revision: "15"

expanded class
	EL_STRING_32_ROUTINES

inherit
	EL_STRING_X_ROUTINES [STRING_32]

	EL_SHARED_ONCE_STRING_32

	EL_SHARED_ONCE_STRING_8

feature -- Basic operations

	append_to (str: STRING_32; extra: READABLE_STRING_GENERAL)
		do
			if attached {ZSTRING} extra as zstr then
				zstr.append_to_string_32 (str)
			else
				str.append_string_general (extra)
			end
		end

feature -- Conversion

	cursor (s: READABLE_STRING_32): EL_STRING_32_ITERATION_CURSOR
		do
			Result := Once_cursor
			Result.make (s)
		end

	from_general (str: READABLE_STRING_GENERAL; keep_ref: BOOLEAN): STRING_32
		do
			if attached {STRING_32} str as str_32 then
				Result := str_32
			else
				Result := once_empty_string_32
				if attached {ZSTRING} str as z_str then
					z_str.append_to_string_32 (Result)
				else
					Result.append_string_general (str)
				end
				if keep_ref then
					Result := Result.twin
				end
			end
		end

	to_code_array (s: STRING_32): ARRAY [NATURAL_32]
		local
			i: INTEGER
		do
			create Result.make_filled (0, 1, s.count)
			from i := 1 until i > s.count loop
				Result [i] := s.code (i).to_natural_8
				i := i + 1
			end
		end

	to_utf_8 (str: READABLE_STRING_32; keep_ref: BOOLEAN): STRING
		local
			c: EL_UTF_CONVERTER
		do
			Result := once_empty_string_8
			c.utf_32_string_into_utf_8_string_8 (str, Result)
			if keep_ref then
				Result := Result.twin
			end
		end

feature -- Measurement

	latin_1_count (s: STRING_32): INTEGER
		-- count of latin-1 characters
		local
			i, count: INTEGER; area: SPECIAL [CHARACTER_32]
		do
			area := s.area; count := s.count
			from i := 0 until i = count loop
				if area.item (i).natural_32_code <= 0xFF then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	left_white_count (s: STRING_32): INTEGER
		local
			i, l_count: INTEGER; l_area: SPECIAL [CHARACTER_32]
			p: like Character_properties
		do
			p := Character_properties; l_count := s.count; l_area := s.area
			from until i = l_count or else not p.is_space (l_area.item (i)) loop
				i := i + 1
			end
			Result := i
		end

	right_white_count (s: STRING_32): INTEGER
		local
			i, nb: INTEGER; l_area: SPECIAL [CHARACTER_32]
			p: like Character_properties
		do
			p := Character_properties; l_area := s.area
			from
				nb := s.count - 1; i := nb
			until
				i < 0 or else not p.is_space (l_area.item (i))
			loop
				Result := Result + 1
				i := i - 1
			end
		end

feature -- Transformation

	left_adjust (str: STRING_32)
		do
			str.left_adjust
		end

	prune_all_leading (str: STRING_32; c: CHARACTER_32)
		do
			str.prune_all_leading (c)
		end

	right_adjust (str: STRING_32)
		do
			str.right_adjust
		end

feature {NONE} -- Constants

	Character_properties: CHARACTER_PROPERTY
			-- Access to Unicode character properties
		once
			create Result.make
		end

feature {NONE} -- Constants

	Once_cursor: EL_STRING_32_ITERATION_CURSOR
		once
			create Result.make_empty
		end
end