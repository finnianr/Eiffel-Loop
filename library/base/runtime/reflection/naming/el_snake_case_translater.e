note
	description: "Translating: Snake_Case <--> snake_case"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-15 11:08:13 GMT (Wednesday 15th June 2022)"
	revision: "1"

class
	EL_SNAKE_CASE_TRANSLATER

inherit
	EL_NAME_TRANSLATER

create
	make_upper, make_title

feature -- Conversion

	exported (eiffel_name: STRING): STRING
		-- `eiffel_name' exported to a foreign naming convention
		do
			create Result.make (eiffel_name.count)
			inspect foreign_case
				when Case_upper then
					Naming.to_snake_case_upper (eiffel_name, Result)

				when Case_title then
					Naming.to_title (eiffel_name, Result, '_', Naming.no_words)
			else
				Result.append (eiffel_name)
			end
		end

	imported (foreign_name: STRING): STRING
		-- `foreign_name' translated to Eiffel attribute-naming convention
		do
			create Result.make (foreign_name.count)
			Naming.from_snake_case_upper (foreign_name, Result)
		end
end