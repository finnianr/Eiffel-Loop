note
	description: "Summary description for {PP_NAME_VALUE_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-18 5:58:13 GMT (Monday 18th December 2017)"
	revision: "2"

class
	PP_NAME_VALUE_PARAMETER

inherit
	EL_HTTP_NAME_VALUE_PARAMETER
		rename
			make as make_http_parameter
		end

	PP_SHARED_PARAMETER_ENUM

create
	make

feature {NONE} -- Initialization

	make (param: NATURAL_8; a_value: like value)
		require
			valid_code: Parameter.is_valid_value (param)
		do
			make_http_parameter (Parameter.name (param), a_value)
		end
end
