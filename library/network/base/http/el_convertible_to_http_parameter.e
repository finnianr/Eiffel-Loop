note
	description: "Object that is convertible to type conforming to ${EL_HTTP_PARAMETER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-06 11:06:59 GMT (Wednesday 6th December 2023)"
	revision: "1"

deferred class
	EL_CONVERTIBLE_TO_HTTP_PARAMETER

feature -- Access

	to_parameter: EL_HTTP_PARAMETER
		deferred
		end

end