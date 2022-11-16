note
	description: "Unix implementation of cURL option constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

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