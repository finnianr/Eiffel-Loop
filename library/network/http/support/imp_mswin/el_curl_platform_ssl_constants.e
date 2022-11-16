note
	description: "SSL constants implemented in libcurl Unix but not in Windows"
	notes: "[
		Windows is fixed on libcurl version 7.17.0 whereas Unix is based on the OS distribution libcurl version.
		
		The following SSL constants are not found in version 7.17.0
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_CURL_PLATFORM_SSL_CONSTANTS

feature -- Access

	curl_sslversion_TLSv1_0: INTEGER
			-- Declared as CURL_SSLVERSION_TLSv1_0
		require
			windows_curl_api_upgraded: False
		do
		end

	curl_sslversion_TLSv1_1: INTEGER
			-- Declared as CURL_SSLVERSION_TLSv1_1
		require
			windows_curl_api_upgraded: False
		do
		end

	curl_sslversion_TLSv1_2: INTEGER
			-- Declared as CURL_SSLVERSION_TLSv1_2
		require
			windows_curl_api_upgraded: False
		do
		end

end