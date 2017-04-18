note
	description: "Windows implementation of cURL option constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-17 12:52:41 GMT (Monday 17th April 2017)"
	revision: "1"

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
