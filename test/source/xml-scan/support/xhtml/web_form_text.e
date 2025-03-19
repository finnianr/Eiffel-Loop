note
	description: "Web form text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:03:40 GMT (Tuesday 18th March 2025)"
	revision: "7"

class
	WEB_FORM_TEXT

inherit
	WEB_FORM_COMPONENT

	EVC_SERIALIZEABLE_TEXT_VALUE
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