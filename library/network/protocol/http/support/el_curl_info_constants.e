note
	description: "Extra info constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "2"

class
	EL_CURL_INFO_CONSTANTS

inherit
	CURL_INFO_CONSTANTS
		rename
			is_valid as is_valid_curl_info_option
		redefine
			is_valid_curl_info_option
		end

feature -- Contract support

	is_valid_curl_info_option (a_code: INTEGER): BOOLEAN
		do
			Result := Precursor (a_code) or else a_code = CURLINFO_redirect_url
		end

feature {NONE} -- Constants

	CURLINFO_redirect_url: INTEGER
		once
			Result := Curlinfo_string + 31
		end

end
