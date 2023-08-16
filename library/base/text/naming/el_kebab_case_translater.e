note
	description: "Translating: kebab-case <--> kebab_case"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-15 15:18:09 GMT (Tuesday 15th August 2023)"
	revision: "6"

class
	EL_KEBAB_CASE_TRANSLATER

inherit
	EL_NAME_TRANSLATER

create
	make, make_case

convert
	make_case ({NATURAL})

feature -- Conversion

	exported (eiffel_name: READABLE_STRING_8): STRING
		-- `eiffel_name' exported to a foreign naming convention
		do
			create Result.make (eiffel_name.count)
			inspect foreign_case
				when {EL_CASE}.upper then
					to_kebab_case_upper (eiffel_name, Result)

				when {EL_CASE}.title then
					to_title (eiffel_name, Result, '-', uppercase_exception_set)
			else
				to_kebab_case_lower (eiffel_name, Result)
			end
		end

	imported (foreign_name: READABLE_STRING_8): STRING
		-- `foreign_name' translated to Eiffel attribute-naming convention
		do
			create Result.make (foreign_name.count)
			from_kebab_case (foreign_name, Result)
		end

end