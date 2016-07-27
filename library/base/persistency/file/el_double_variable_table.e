note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-02 7:01:53 GMT (Saturday 2nd July 2016)"
	revision: "4"

class
	EL_DOUBLE_VARIABLE_TABLE

inherit
	EL_VARIABLE_TABLE [DOUBLE]

create
	make_from_file_in_location

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