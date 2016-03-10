note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:22 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	WEB_FORM_LINE_BREAK

inherit
	WEB_FORM_COMPONENT

create
	make

feature {NONE} -- Implementation

	building_action_table: like Type_building_actions
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
