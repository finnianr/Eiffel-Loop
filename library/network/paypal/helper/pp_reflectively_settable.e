note
	description: "Pp reflectively settable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

deferred class
	PP_REFLECTIVELY_SETTABLE

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_paypal_field
		end

feature {NONE} -- Implementation

	is_paypal_field (basic_type, type_id: INTEGER_32): BOOLEAN
		do
			Result := is_string_or_expanded_field (basic_type, type_id) or else is_date_field (basic_type, type_id)
		end

end