note
	description: "Summary description for {EL_REFERENCE_FIELD_VALUE_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-24 13:32:53 GMT (Tuesday 24th January 2017)"
	revision: "1"

class
	EL_REFERENCE_FIELD_VALUE_TABLE [G]

inherit
	EL_FIELD_VALUE_TABLE [G]

create
	make

feature {EL_PERSISTENCE_ROUTINES} -- Access

	set_value (key: STRING; object: REFLECTED_REFERENCE_OBJECT; field_index: INTEGER)
		do
			if attached {G} object.reference_field (field_index) as value then
				set_conditional_value (key, value)
			end
		end

	value_type_id: INTEGER
		do
			Result := value_type.type_id
		end
end
