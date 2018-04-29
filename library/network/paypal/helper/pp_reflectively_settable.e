note
	description: "Summary description for {PP_REFLECTIVELY_SETTABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-28 18:00:06 GMT (Saturday 28th April 2018)"
	revision: "1"

deferred class
	PP_REFLECTIVELY_SETTABLE

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_paypal_field
		end

feature {NONE} -- Implementation

	is_paypal_field (object: REFLECTED_REFERENCE_OBJECT; index: INTEGER_32): BOOLEAN
		do
			Result := is_string_or_expanded_field (object, index) or else is_date_field (object, index)
		end

end
