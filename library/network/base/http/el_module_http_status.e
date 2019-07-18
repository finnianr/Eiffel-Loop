note
	description: "Access to a shared instance of [$source EL_HTTP_STATUS_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:59:07 GMT (Monday 1st July 2019)"
	revision: "7"

deferred class
	EL_MODULE_HTTP_STATUS

inherit
	EL_MODULE

feature {NONE} -- Constants

	Http_status: EL_HTTP_STATUS_ENUM
		once
			create Result.make
		end

end
