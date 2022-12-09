note
	description: "Implementation of [$source EL_FIELD_VALUE_TABLE] for reference field attribute types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-09 9:33:36 GMT (Friday 9th December 2022)"
	revision: "6"

class
	EL_REFERENCE_FIELD_VALUE_TABLE [G]

inherit
	EL_FIELD_VALUE_TABLE [G]

create
	make

feature -- Access

	set_value (key: STRING; a_value: ANY)
		do
			if attached {G} a_value as value then
				set_conditional_value (key, value)
			end
		end
end