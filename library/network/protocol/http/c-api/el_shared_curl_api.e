note
	description: "Shared curl api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_SHARED_CURL_API

feature {NONE} -- Constants

	Curl: EL_CURL_API
		once ("PROCESS")
			create Result.make
		end
end
