note
	description: "[
		Translate English/Eiffel names: "English name" <-> english_name (first letter is capitalized)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-15 15:17:47 GMT (Tuesday 15th August 2023)"
	revision: "9"

class
	EL_ENGLISH_NAME_TRANSLATER

inherit
	EL_NAME_TRANSLATER

create
	make, make_case

convert
	make_case ({NATURAL})

feature -- Conversion

	exported (eiffel_name: READABLE_STRING_8): STRING
		-- `eiffel_name' exported to a foreign naming convention
		local
			s: EL_STRING_8_ROUTINES
		do
			create Result.make (eiffel_name.count)
			to_english (eiffel_name, Result, uppercase_exception_set)
			inspect foreign_case
				when {EL_CASE}.lower then
					Result.to_lower
					s.set_upper (Result, 1)

				when {EL_CASE}.title then
					if attached Split_intervals as list then
						list.wipe_out
						list.fill (Result, ' ', 0)
						from list.start until list.after loop
							s.set_upper (Result, list.item_lower)
							list.forth
						end
					end

				when {EL_CASE}.upper then
					Result.to_upper
			else
			end
		end

	imported (foreign_name: READABLE_STRING_8): STRING
		-- `foreign_name' translated to Eiffel attribute-naming convention
		local
			s: EL_STRING_8_ROUTINES
		do
			create Result.make (foreign_name.count)
			if attached Name_buffer.copied (foreign_name) as name then
				s.replace_character (name, ' ', '-')
				from_kebab_case (name, Result)
			end
		end

feature {NONE} -- Constants

	Split_intervals: EL_SPLIT_INTERVALS
		once
			create Result.make_empty
		end

end