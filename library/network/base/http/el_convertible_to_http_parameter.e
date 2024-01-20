note
	description: "Object that is convertible to type conforming to ${EL_HTTP_PARAMETER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "2"

deferred class
	EL_CONVERTIBLE_TO_HTTP_PARAMETER

feature -- Access

	to_parameter: EL_HTTP_PARAMETER
		deferred
		end

end