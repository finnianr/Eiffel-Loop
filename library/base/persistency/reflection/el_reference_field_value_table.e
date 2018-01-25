note
	description: "Summary description for {EL_REFERENCE_FIELD_VALUE_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-10 15:33:31 GMT (Sunday 10th December 2017)"
	revision: "2"

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
