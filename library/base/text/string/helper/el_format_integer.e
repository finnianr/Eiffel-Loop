note
	description: "[$source FORMAT_INTEGER] with ability to spell numbers in English from 0 to 99"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-12 12:47:57 GMT (Sunday 12th March 2023)"
	revision: "1"

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
			inspect i
				when 0 .. 12 then
					Result := Numbers_1_to_12.i_th (i + 1)
				when 13, 15 .. 19 then
					Result := Stems_over_20.i_th (i - 11) + Suffix_teen
				when 14 then -- fourteen (not forteen)
					Result := Numbers_1_to_12.i_th (5) + Suffix_teen
				when 20 .. 99 then
					tens := i // 10; remainder := i \\ 10
					Result := Stems_over_20.i_th (tens - 1) + Suffix_ty
					if remainder > 0 then
						Result.append_character ('-')
						Result.append (Numbers_1_to_12.i_th (remainder + 1))
					end
			else
				Result := i.out
			end
		end

feature {NONE} -- Constants

	Suffix_teen: STRING = "teen"

	Suffix_ty: STRING = "ty"

	Numbers_1_to_12: EL_SPLIT_STRING_8_LIST
		once
			create Result.make_adjusted (
				"zero, one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve",
				',', {EL_STRING_ADJUST}.Left
			)
		end

	Stems_over_20: EL_SPLIT_STRING_8_LIST
		once
			create Result.make_adjusted (
				"twen, thir, for, fif, six, seven, eigh, nine", ',', {EL_STRING_ADJUST}.Left
			)
		end

end