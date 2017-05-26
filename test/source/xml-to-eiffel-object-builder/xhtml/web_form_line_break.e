note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 20:17:41 GMT (Sunday 21st May 2017)"
	revision: "2"

class
	WEB_FORM_LINE_BREAK

inherit
	WEB_FORM_COMPONENT
		rename
			make_default as make
		end

create
	make

feature {NONE} -- Implementation

	building_action_table: EL_PROCEDURE_TABLE
			--
		do
			create Result
		end

	getter_function_table: like getter_functions
			--
		do
			create Result
		end

	Template: STRING = "<br/>"

end
