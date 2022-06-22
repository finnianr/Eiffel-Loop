note
	description: "Web form text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-18 12:42:33 GMT (Friday 18th January 2019)"
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

feature {NONE} -- Implementation

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result
		end

end