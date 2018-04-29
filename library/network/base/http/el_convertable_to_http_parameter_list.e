note
	description: "Reflectively convertible to HTTP parameter list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-28 17:19:01 GMT (Saturday 28th April 2018)"
	revision: "1"

deferred class
	EL_CONVERTABLE_TO_HTTP_PARAMETER_LIST

inherit
	EL_REFLECTIVELY_SETTABLE

feature -- Access

	to_parameter_list: EL_HTTP_PARAMETER_LIST
		do
			create Result.make_from_object (Current)
		end

end
