note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-24 14:52:03 GMT (Thursday 24th December 2015)"
	revision: "5"

class
	WEB_FORM_TEXT

inherit
	WEB_FORM_COMPONENT

	EVOLICITY_SERIALIZEABLE_TEXT_VALUE
		undefine
			new_getter_functions, make_default
		end

create
	make

feature {NONE} -- Initialization

	make (s: STRING)
			--
		do
			text := s
			make_default
		end

feature {NONE} -- Implementation

	building_action_table: like Type_building_actions
			--
		do
			create Result
		end

end
