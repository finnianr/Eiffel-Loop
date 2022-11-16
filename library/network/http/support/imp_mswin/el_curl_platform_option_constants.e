note
	description: "Windows implementation of cURL option constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_CURL_PLATFORM_OPTION_CONSTANTS

feature -- HTTP

	CURLOPT_copypostfields: INTEGER
			-- Not yet defined for Windows cURL implementation
		require
			is_defined: False
		do
		end

end