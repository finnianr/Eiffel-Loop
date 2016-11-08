note
	description: "[
		Performs a http HEAD request using the connection `connection' and stores
		the data in the string `string'. Windows style newlines ("%R%N") are converted to Unix style.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-09-27 8:07:46 GMT (Tuesday 27th September 2016)"
	revision: "2"

class
	EL_HEADER_DOWNLOAD_HTTP_COMMAND

inherit
	EL_STRING_DOWNLOAD_HTTP_COMMAND
		redefine
			callback_curl_option, callback_curl_data_option
		end

create
	make

feature {NONE} -- Implementation

	callback_curl_option: INTEGER
		do
			Result := CURLOPT_headerfunction
		end

	callback_curl_data_option: INTEGER
		do
			Result := CURLOPT_headerdata
		end

end
