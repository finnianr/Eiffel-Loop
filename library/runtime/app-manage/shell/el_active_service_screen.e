note
	description: "Service screen that is present in the output of command `screen -list'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-01 9:36:01 GMT (Tuesday 1st February 2022)"
	revision: "1"

class
	EL_ACTIVE_SERVICE_SCREEN

inherit
	EL_SERVICE_SCREEN
		redefine
			new_command_parts, sort_prefix, Transition_name
		end

	EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (other: EL_SERVICE_SCREEN; a_id: INTEGER)
		do
			set_from_other (other, Empty_string_8)
			id := a_id
		end

feature -- Access

	id: INTEGER
		-- screen id

feature {NONE} -- Implementation

	new_command_parts: EL_ZSTRING_LIST
		do
			create Result.make_from_array (<< Screen,  "-r", id.out >>)
		end

feature {NONE} -- Constants

	Sort_prefix: ZSTRING
		once
			Result := "A-"
		end

	Transition_name: ZSTRING
		once
			Result := "View"
		end

end