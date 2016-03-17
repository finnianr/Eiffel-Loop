note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-24 14:49:11 GMT (Thursday 24th December 2015)"
	revision: "4"

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
