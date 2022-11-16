note
	description: "Double variable table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_DOUBLE_VARIABLE_TABLE

inherit
	EL_VARIABLE_TABLE [DOUBLE]

create
	make_from_file

feature {NONE} -- Implementation

	value_from_string (string: STRING): DOUBLE
			--
		do
			Result := string.to_double
		end

	variable_not_found (variable: STRING; value: DOUBLE)
			--
		do
--			log.enter_with_args ("variable_not_found", << variable >>)
--			log.put_line ("NOT same value")
--			log.put_string ("value: ")
--			log.put_double (value)
--			log.put_new_line
--			log.put_string ("Table value: ")
--			log.put_double (item (variable))
--			log.put_new_line
--			log.exit
		end

end