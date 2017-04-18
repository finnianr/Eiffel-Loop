note
	description: "SSL constants implemented in Unix but not in Windows"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-12 13:35:12 GMT (Wednesday 12th April 2017)"
	revision: "1"

class
	EL_CURL_PLATFORM_SSL_CONSTANTS

feature -- Access

	curl_sslversion_TLSv1_0: INTEGER
			-- Declared as CURL_SSLVERSION_TLSv1
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURL_SSLVERSION_TLSv1_0"
		end

	curl_sslversion_TLSv1_1: INTEGER
			-- Declared as CURL_SSLVERSION_TLSv1_1
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURL_SSLVERSION_TLSv1_1"
		end

	curl_sslversion_TLSv1_2: INTEGER
			-- Declared as CURL_SSLVERSION_TLSv1_2
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURL_SSLVERSION_TLSv1_2"
		end

end
