note
	description: "[
		Reflectively convertible to HTTP parameter either as a ${EL_HTTP_PARAMETER_LIST}
		or a ${EL_HTTP_NAME_VALUE_PARAMETER}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-06 11:07:58 GMT (Wednesday 6th December 2023)"
	revision: "3"

deferred class
	EL_REFLECTIVELY_CONVERTIBLE_TO_HTTP_PARAMETER

inherit
	EL_CONVERTIBLE_TO_HTTP_PARAMETER
		undefine
			is_equal
		end

	EL_REFLECTIVELY_SETTABLE

feature -- Access

	to_parameter: EL_HTTP_PARAMETER
		do
			if attached meta_data.field_list as field_list then
				if field_list.count = 1 then
					create {EL_HTTP_NAME_VALUE_PARAMETER} Result.make_from_field (Current, field_list [1])
				else
					create {EL_HTTP_PARAMETER_LIST} Result.make_from_object (Current)
				end
			end
		end

end