note
	description: "Access to a shared instance of [$source EL_HTTP_STATUS_CODES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-02 10:55:49 GMT (Friday 2nd March 2018)"
	revision: "4"

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
