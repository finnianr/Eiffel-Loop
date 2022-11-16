note
	description: "Shared curl api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

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