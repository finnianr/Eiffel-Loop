note
	description: "Access to a shared instance of [$source EL_HTTP_STATUS_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-04 15:45:27 GMT (Wednesday 4th April 2018)"
	revision: "5"

class
	EL_MODULE_HTTP_STATUS

inherit
	EL_MODULE

feature -- Access

	Http_status: EL_HTTP_STATUS_ENUM
		once
			create Result.make
		end

end
