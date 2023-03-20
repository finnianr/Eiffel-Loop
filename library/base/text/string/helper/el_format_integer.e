note
	description: "[$source FORMAT_INTEGER] with ability to spell numbers in English from 0 to 99"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-20 9:58:03 GMT (Monday 20th March 2023)"
	revision: "4"

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

feature {NONE} -- Constants

	Suffix_teen: STRING = "teen"

	Suffix_ty: STRING = "ty"

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

end