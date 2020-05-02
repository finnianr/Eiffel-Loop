note
	description: "Object that is reflectively convertable to a Paypal HTTP parameter list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-28 8:26:44 GMT (Tuesday 28th April 2020)"
	revision: "2"

class
	PP_CONVERTABLE_TO_PARAMETER_LIST

inherit
	EL_CONVERTABLE_TO_HTTP_PARAMETER_LIST
		rename
			field_included as is_paypal_field,
			import_name as from_snake_case_upper, -- for reading PP_CREDENTIALS from file
			export_name as to_camel_case_upper
		end

	PP_REFLECTIVELY_SETTABLE
		rename
			import_name as from_snake_case_upper, -- for reading PP_CREDENTIALS from file
			export_name as to_camel_case_upper
		end

end
