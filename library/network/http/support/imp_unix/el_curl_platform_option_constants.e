note
	description: "Unix implementation of cURL option constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-30 9:23:32 GMT (Thursday 30th June 2022)"
	revision: "3"

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