note
	description: "Fast lookup of code in unencoded intervals array"
	notes: "Can be optimized by using an array of indices into `area'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-17 14:38:07 GMT (Friday 17th February 2023)"
	revision: "14"

class
	EL_UNENCODED_CHARACTERS_INDEX

inherit
	EL_ZCODE_CONVERSION

	EL_SHARED_UTF_8_SEQUENCE

create
	make, make_default

feature {NONE} -- Initialization

	make (a_area: like area)
		do
			utf_8 := Utf_8_sequence
			set_area (a_area)
		end

	make_default
		do
			utf_8 := Utf_8_sequence
			create area.make_empty (0)
		end

feature -- Access

	code (index: INTEGER): NATURAL
		do
			Result := item (index).natural_32_code
		end

	index_of (uc: CHARACTER_32; start_index: INTEGER): INTEGER
		-- index of `unicode' starting from `start_index'
		local
			lower, upper, i, j: INTEGER
			l_area: like area; found: BOOLEAN
		do
			l_area := area; i := area_index
			lower := l_area [i].code
			if start_index < lower then
				i := 0
			end
			from until found or else i = l_area.count loop
				upper := l_area [i + 1].code
				if start_index <= upper then
					found := True
				else
					i := i + upper - l_area [i].code + 3
				end
			end
			if found then
				from until Result > 0 or else i = l_area.count loop
					lower := l_area [i].code; upper := l_area [i + 1].code
					from j := lower.max (start_index) until Result > 0 or else j > upper loop
						if l_area [i + 2 + j - lower] = uc then
							Result := j
						end
						j := j + 1
					end
					if Result = 0 then
						i := i + upper - lower + 3
					end
				end
				if i = l_area.count then
					area_index := 0
				else
					area_index := i
				end
			end
		ensure
			valid_result: Result > 0 implies item (Result) = uc
		end

	item (index: INTEGER): CHARACTER_32
		require
			valid_index: valid_index (index)
		local
			i, i_final, lower, upper: INTEGER
			l_area: like area
		do
			i := area_index ; l_area := area
			lower := l_area [i].code
			if index < lower then
				i := 0
				lower := l_area [i].code
			end
			upper := l_area [i + 1].code
			if index > upper then
				i_final := l_area.count
				from until index <= upper or else i = i_final loop
					i := i + upper - lower + 3
					lower := l_area [i].code; upper := l_area [i + 1].code
				end
			end
			Result := l_area [2 + i + index - lower]
			area_index := i
		end

	z_code (index: INTEGER): NATURAL
		do
			Result := unicode_to_z_code (item (index).natural_32_code)
		end

feature -- Measurement

	occurrences (uc: CHARACTER_32): INTEGER
		-- untested
		local
			i, j, lower, upper: INTEGER; l_area: like area
		do
			l_area := area
			from i := 0 until i = l_area.count loop
				lower := l_area [i].code; upper := l_area [i + 1].code
				from j := lower until j > upper loop
					if l_area [2 + i + j - lower] = uc then
						Result := Result + 1
					end
					j := j + 1
				end
				i := i + upper - lower + 3
			end
		end

feature -- Status query

	same_caseless_characters (other_area: like area; index, other_i, comparison_count: INTEGER): BOOLEAN
		local
			lower, i: INTEGER; l_area: like area; c32: EL_CHARACTER_32_ROUTINES
		do
		--	`area_index' is set as side effect of calling `item (index)'
			if c32.to_lower (item (index)) = c32.to_lower (other_area [other_i]) then
				i := area_index
				l_area := area; lower := l_area [i].code
				Result := c32.same_caseless_sub_array (l_area, other_area, i + 2 + index - lower, other_i, comparison_count)
			end
		end

	same_characters (other_area: like area; index, other_i, comparison_count: INTEGER): BOOLEAN
		local
			lower, i: INTEGER; l_area: like area
		do
		--	`area_index' is set as side effect of calling `item (index)'
			if item (index) = other_area [other_i] then
				i := area_index
				l_area := area; lower := l_area [i].code
				Result := l_area.same_items (other_area, other_i, i + 2 + index - lower, comparison_count)
			end
		end

	valid_index (index: INTEGER): BOOLEAN
		local
			i, lower, upper, i_final: INTEGER; l_area: like area
		do
			l_area := area
			from i := 0 until Result or else i = l_area.count loop
				lower := l_area [i].code; upper := l_area [i + 1].code
				if lower <= index and then index <= upper then
					Result := True
				else
					i := i + upper - lower + 3
				end
			end
		end

feature -- Element change

	set_area (a_area: like area)
		do
			area_index := 0
			area := a_area
		end

feature -- Basic operations

	write_to_utf_8 (index: INTEGER; utf_8_out: STRING)
		do
			utf_8.set_area (code (index))
			utf_8.append_to_string (utf_8_out)
		end

feature {EL_UNENCODED_CHARACTERS} -- Internal attributes

	area: SPECIAL [CHARACTER_32]
		-- unencoded character area

	area_index: INTEGER

	utf_8: EL_UTF_8_SEQUENCE

end