note
	description: "Curl ssl constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_CURL_SSL_CONSTANTS

inherit
	EL_CURL_PLATFORM_SSL_CONSTANTS

feature -- Access

	curl_sslversion_default: INTEGER
			-- Declared as CURL_SSLVERSION_DEFAULT
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURL_SSLVERSION_DEFAULT"
		end

	curl_sslversion_sslv2: INTEGER
			-- Declared as CURL_SSLVERSION_SSLv2
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURL_SSLVERSION_SSLv2"
		end

	curl_sslversion_sslv3: INTEGER
			-- Declared as CURL_SSLVERSION_SSLv3
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURL_SSLVERSION_SSLv3"
		end

	curl_sslversion_TLSv1: INTEGER
			-- Declared as CURL_SSLVERSION_TLSv1
		external
			"C [macro <curl/curl.h>]: EIF_INTEGER"
		alias
			"CURL_SSLVERSION_TLSv1"
		end

end