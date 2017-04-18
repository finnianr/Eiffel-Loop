note
	description: "Unix implementation of cURL option constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-17 12:51:36 GMT (Monday 17th April 2017)"
	revision: "1"

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
