note
	description: "Object that is reflectively convertable to a Paypal HTTP parameter list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	PP_CONVERTABLE_TO_PARAMETER_LIST

inherit
	EL_CONVERTABLE_TO_HTTP_PARAMETER_LIST
		rename
			field_included as is_paypal_field,
			foreign_naming as Camel_case_upper
		end

	PP_REFLECTIVELY_SETTABLE
		rename
			foreign_naming as Camel_case_upper
		end

feature {NONE} -- Constants

	Camel_case_upper: EL_CAMEL_CASE_TRANSLATER
		once
			Result := {EL_CASE}.Upper
		end
end