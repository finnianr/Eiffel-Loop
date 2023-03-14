note
	description: "[$source FORMAT_INTEGER] with ability to spell numbers in English from 0 to 99"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-13 8:42:54 GMT (Monday 13th March 2023)"
	revision: "2"

class
	EL_FORMAT_INTEGER

inherit
	FORMAT_INTEGER

	EL_MODULE_TUPLE

create
	make

feature -- Conversion

	spell (i: INTEGER): STRING
		require
			valid_range: 0 <= i and i <= 99
		local
			tens, remainder: INTEGER
		do
			create Result.make (15)
			inspect i
				when 0 .. 12 then
					Spell_0_to_12.append_i_th_to (i + 1, Result)
				when 13 .. 19 then
					if i = 14 then
					-- fourteen (not forteen)
						Spell_0_to_12.append_i_th_to (5, Result)
					else
						Stems_20_upwards.append_i_th_to (i - 11, Result)
					end
					Result.append (Suffix_teen)

				when 20 .. 99 then
					tens := i // 10; remainder := i \\ 10
					Result.append (Stems_20_upwards.i_th (tens - 1))
					Result.append (Suffix_ty)

					if remainder > 0 then
						Result.append_character ('-')
						Spell_0_to_12.append_i_th_to (remainder + 1, Result)
					end
			else
				Result.append_integer (i)
			end
		end

feature {NONE} -- Constants

	Suffix_teen: STRING = "teen"

	Suffix_ty: STRING = "ty"

	Spell_0_to_12: EL_SPLIT_STRING_8_LIST
		once
			create Result.make_adjusted (
				"zero, one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve",
				',', {EL_STRING_ADJUST}.Left
			)
		end

	Stems_20_upwards: EL_SPLIT_STRING_8_LIST
		once
			create Result.make_adjusted (
				"twen, thir, for, fif, six, seven, eigh, nine", ',', {EL_STRING_ADJUST}.Left
			)
		end

end