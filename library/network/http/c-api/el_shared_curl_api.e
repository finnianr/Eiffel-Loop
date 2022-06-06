note
	description: "Shared curl api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:25:12 GMT (Monday 1st July 2019)"
	revision: "5"

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
