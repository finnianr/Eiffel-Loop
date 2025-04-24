note
	description: "Access to a shared instance of ${EL_HTTP_STATUS_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-24 13:51:49 GMT (Thursday 24th April 2025)"
	revision: "11"

deferred class
	EL_SHARED_HTTP_STATUS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Http_status: EL_HTTP_STATUS_ENUM
		once
			create Result.make
		end

end