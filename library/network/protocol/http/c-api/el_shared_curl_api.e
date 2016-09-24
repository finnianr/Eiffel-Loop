note
	description: "Summary description for {EL_SHARED_CURL_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-09-18 12:50:19 GMT (Sunday 18th September 2016)"
	revision: "1"

class
	EL_SHARED_CURL_API

feature {NONE} -- Constants

	Curl: EL_CURL_API
		once ("PROCESS")
			create Result.make
		end
end
