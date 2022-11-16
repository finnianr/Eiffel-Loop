note
	description: "Fast lookup of code in unencoded intervals array"
	notes: "Can be optimized by using an array of indices into `area'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "12"

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
			lower, upper, i, i_final, j: INTEGER
			l_area: like area; found: BOOLEAN
		do
			l_area := area; i_final := l_area.count; i := area_index
			lower := lower_bound (l_area, i)
			if start_index < lower then
				i := 0
			end
			from until found or else i = i_final loop
				upper := upper_bound (l_area, i)
				if start_index <= upper then
					found := True
				else
					i := i + upper - lower_bound (l_area, i) + 3
				end
			end
			if found then
				from until Result > 0 or else i = i_final loop
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
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
				if i = i_final then
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
			lower := lower_bound (l_area, i)
			if index < lower then
				i := 0
				lower := lower_bound (l_area, i)
			end
			upper := upper_bound (l_area, i)
			if index > upper then
				i_final := l_area.count
				from until index <= upper or else i = i_final loop
					i := i + upper - lower + 3
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
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
			i, j, lower, upper, i_final: INTEGER; l_area: like area
		do
			l_area := area; i_final := l_area.count
			from i := 0 until i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
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

	valid_index (index: INTEGER): BOOLEAN
		local
			i, lower, upper, i_final: INTEGER; l_area: like area
		do
			l_area := area; i_final := l_area.count
			from i := 0 until Result or else i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
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

feature {NONE} -- Implementation

	lower_bound (a_area: like area; i: INTEGER): INTEGER
		do
			Result := a_area [i].natural_32_code.to_integer_32
		end

	upper_bound (a_area: like area; i: INTEGER): INTEGER
		do
			Result := a_area [i + 1].natural_32_code.to_integer_32
		end

feature {EL_UNENCODED_CHARACTERS} -- Internal attributes

	area: SPECIAL [CHARACTER_32]
		-- unencoded character area

	area_index: INTEGER

	utf_8: EL_UTF_8_SEQUENCE

end