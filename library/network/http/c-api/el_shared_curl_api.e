note
	description: "Shared instance of ${EL_CURL_API} for ${EL_CURL_HTTP_CONNECTION}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-15 16:25:19 GMT (Saturday 15th November 2025)"
	revision: "7"

deferred class
	EL_SHARED_CURL_API

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Curl: EL_CURL_API
		once ("PROCESS")
			create Result.make
		end
end