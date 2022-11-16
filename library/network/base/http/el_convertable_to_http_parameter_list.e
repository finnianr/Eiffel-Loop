note
	description: "Reflectively convertible to HTTP parameter list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

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