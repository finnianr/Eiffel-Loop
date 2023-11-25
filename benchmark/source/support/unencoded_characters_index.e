note
	description: "Fast lookup of item in unencoded intervals array by caching **area_index**"
	notes: "Can be optimized by using an array of indices into `area'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-25 9:26:41 GMT (Saturday 25th November 2023)"
	revision: "18"

class
	UNENCODED_CHARACTERS_INDEX

obsolete
	"Replaced by EL_UNENCODED_CHARACTER_ITERATION"

inherit
	EL_ZCODE_CONVERSION

create
	make, make_default

feature {NONE} -- Initialization

	make (a_area: like area)
		do
			set_area (a_area)
		end

	make_default
		do
			create area.make_empty (0)
		end

feature -- Access

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

	valid_index (index: INTEGER): BOOLEAN
		local
			i, lower, upper: INTEGER; l_area: like area
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

feature {EL_UNENCODED_CHARACTERS} -- Internal attributes

	area: SPECIAL [CHARACTER_32]
		-- unencoded character area

	area_index: INTEGER

end