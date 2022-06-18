note
	description: "Translating: kebab-case <--> kebab_case"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 18:38:20 GMT (Thursday 16th June 2022)"
	revision: "2"

class
	EL_KEBAB_CASE_TRANSLATER

inherit
	EL_NAME_TRANSLATER

create
	make, make_lower, make_upper, make_title

feature -- Conversion

	exported (eiffel_name: STRING): STRING
		-- `eiffel_name' exported to a foreign naming convention
		do
			create Result.make (eiffel_name.count)
			inspect foreign_case
				when Case_lower then
					to_kebab_case_lower (eiffel_name, Result)

				when Case_upper then
					to_kebab_case_upper (eiffel_name, Result)

				when Case_title then
					to_title (eiffel_name, Result, '-', title_uppercase_word_exception_set)
			else
				to_kebab_case (eiffel_name, Result)
			end
		end

	imported (foreign_name: STRING): STRING
		-- `foreign_name' translated to Eiffel attribute-naming convention
		do
			create Result.make (foreign_name.count)
			from_kebab_case (foreign_name, Result)
		end

feature {NONE} -- Implementation

	title_uppercase_word_exception_set: EL_HASH_SET [STRING]
		do
			Result := empty_word_set
		end

end