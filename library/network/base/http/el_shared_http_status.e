note
	description: "Access to a shared instance of [$source EL_HTTP_STATUS_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "9"

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