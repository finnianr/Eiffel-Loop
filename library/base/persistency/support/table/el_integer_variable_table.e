note
	description: "Integer variable table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_INTEGER_VARIABLE_TABLE

inherit
	EL_VARIABLE_TABLE [INTEGER]

create
	make_from_file

feature {NONE} -- Implementation

	value_from_string (string: STRING): INTEGER
			--
		do
			Result := string.to_integer
		end

	variable_not_found (variable: STRING; value: INTEGER)
			--
		do
--			log.enter_with_args ("variable_not_found", << variable >>)
--			log.put_line ("NOT same value")
--			log.put_integer_field ("value", value)
--			log.put_new_line
--			log.put_integer_field ("Table value", item (variable))
--			log.put_new_line
--			log.exit
		end

end