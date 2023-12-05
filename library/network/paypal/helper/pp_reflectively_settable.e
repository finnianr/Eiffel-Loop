note
	description: "Reflectively settable Paypal object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-05 18:14:57 GMT (Tuesday 5th December 2023)"
	revision: "6"

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