note
	description: "Access to a shared instance of [$source EL_HTTP_STATUS_CODES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-18 5:38:40 GMT (Monday 18th December 2017)"
	revision: "3"

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
