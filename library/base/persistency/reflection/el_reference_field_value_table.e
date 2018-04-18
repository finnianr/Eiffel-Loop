note
	description: "Implementation of [$source EL_FIELD_VALUE_TABLE] for reference field attribute types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-04 12:10:13 GMT (Wednesday 4th April 2018)"
	revision: "3"

class
	EL_REFERENCE_FIELD_VALUE_TABLE [G]

inherit
	EL_FIELD_VALUE_TABLE [G]

create
	make

feature {EL_REFLECTIVELY_SETTABLE} -- Access

	set_value (key: STRING; a_value: ANY)
		do
			if attached {G} a_value as value then
				set_conditional_value (key, value)
			end
		end

	value_type_id: INTEGER
		do
			Result := value_type.type_id
		end
end
