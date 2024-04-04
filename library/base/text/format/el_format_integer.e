note
	description: "${FORMAT_INTEGER} with ability to spell numbers in English from 0 to 99"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-04 10:26:13 GMT (Thursday 4th April 2024)"
	revision: "9"

class
	EL_FORMAT_INTEGER

inherit
	FORMAT_INTEGER
		rename
			make as make_width
		redefine
			formatted
		end

	EL_FORMAT_LIKENESS

create
	make, make_width

convert
	make ({STRING_8})

feature {NONE} -- Initialization

	make_sized (w, d: INTEGER)
		do
			make_width (w)
		end

feature -- Conversion

	formatted (i: INTEGER): STRING
		do
			Result := Precursor (i)
			if is_percentile then
				insert_percent (Result)
			end
		end

	spell (i: INTEGER): STRING
		require
			valid_range: 0 <= i and i <= 99
		local
			tens, remainder: INTEGER
		do
			create Result.make (15)
			inspect i
				when 0 .. 12 then
					Result.append (Spell_0_to_12.i_th (i + 1))
				when 13 .. 19 then
					if i = 14 then
					-- fourteen (not forteen)
						Result.append (Spell_0_to_12.i_th (5))
					else
						Result.append (Stems_20_upwards.i_th (i - 11))
					end
					Result.append (Suffix_teen)

				when 20 .. 99 then
					tens := i // 10; remainder := i \\ 10
					Result.append (Stems_20_upwards.i_th (tens - 1))
					Result.append (Suffix_ty)

					if remainder > 0 then
						Result.append_character ('-')
						Result.append (Spell_0_to_12.i_th (remainder + 1))
					end
			else
				Result.append_integer (i)
			end
		end

feature {NONE} -- Implementation

	parsed_decimal_count (parser: EL_SIMPLE_IMMUTABLE_PARSER_8; decimal_point: CHARACTER_REF): INTEGER
		do
			do_nothing
		end

	set_decimal_point (c: CHARACTER)
		do
			do_nothing
		end

	set_jusitification (justify_right, justify_left: BOOLEAN)
		-- defaults to right justification
		do
			if justify_left and justify_right then
				center_justify

			elseif justify_left then
				left_justify
			else
				right_justify
			end
		end

feature {NONE} -- Constants

	Spell_0_to_12: EL_SPLIT_IMMUTABLE_STRING_8_LIST
		once
			create Result.make_shared_adjusted (
				"zero, one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve",
				',', {EL_SIDE}.Left
			)
		end

	Stems_20_upwards: EL_SPLIT_IMMUTABLE_STRING_8_LIST
		once
			create Result.make_shared_adjusted (
				"twen, thir, for, fif, six, seven, eigh, nine", ',', {EL_SIDE}.Left
			)
		end

	Suffix_teen: STRING = "teen"

	Suffix_ty: STRING = "ty"

note
	notes: "[
		Default justification: right
	
		**Formatting Test Set**
		
		Annotated table from ${STRING_TEST_SET}.test_format_double

			create format_table.make (<<
				["999", " 64"],		-- width = 3, right justified by default
				["|999", "64 "],		-- left justified
				["999|", " 64"],		-- right justified
				["999|", " 64"],		-- right justified
				["0999|", "064"],		-- left justified with zero padding
				["|9999|", " 64 "],	-- centered
				["999%%|", " 64%%"],	-- percentile
				["|999%%", "64%% "] 	-- left justified percentile
			>>)

	]"

end