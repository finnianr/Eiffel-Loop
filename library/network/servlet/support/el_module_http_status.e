note
	description: "Access to a shared instance of `EL_HTTP_STATUS_CODES'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-05 11:28:15 GMT (Sunday 5th November 2017)"
	revision: "1"

class
	EL_MODULE_HTTP_STATUS

inherit
	EL_MODULE

feature -- Access

	Http_status: EL_HTTP_STATUS_CODES
		once
			create Result.make
		end

end
