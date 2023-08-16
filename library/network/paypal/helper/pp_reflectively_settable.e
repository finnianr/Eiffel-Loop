note
	description: "Pp reflectively settable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-20 7:53:33 GMT (Thursday 20th July 2023)"
	revision: "5"

deferred class
	PP_REFLECTIVELY_SETTABLE

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_paypal_field
		end

feature {NONE} -- Implementation

	is_paypal_field (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		do
			Result := field.is_string_or_expanded or else field.conforms_to_date_time
		end

end