note
	description: "Implementation of [$source EL_FIELD_VALUE_TABLE] for reference field attribute types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-16 16:13:57 GMT (Sunday 16th July 2023)"
	revision: "7"

class
	EL_REFERENCE_FIELD_VALUE_TABLE [G]

inherit
	EL_FIELD_VALUE_TABLE [G]

create
	make

feature -- Access

	set_value (key: READABLE_STRING_8; a_value: ANY)
		do
			if attached {G} a_value as value then
				set_conditional_value (key, value)
			end
		end
end