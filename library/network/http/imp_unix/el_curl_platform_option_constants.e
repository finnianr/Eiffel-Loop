note
	description: "Unix implementation of cURL option constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "2"

class
	EL_CURL_PLATFORM_OPTION_CONSTANTS

feature -- HTTP

	CURLOPT_copypostfields: INTEGER
			-- Declared as CURLOPT_POSTFIELDS.
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURLOPT_COPYPOSTFIELDS"
		end

end
