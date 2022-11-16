note
	description: "Web form line break"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "5"

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

	building_action_table: EL_PROCEDURE_TABLE [STRING]
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