note
	description: "Http connection constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-13 14:09:22 GMT (Thursday 13th November 2025)"
	revision: "2"

class
	EL_HTTP_CONNECTION_CONSTANTS

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_HTML; EL_MODULE_TUPLE; EL_MODULE_URI

	EL_CURL_OPTION_CONSTANTS
		export
			{NONE} all
		end

	EL_CURL_SSL_CONSTANTS
		export
			{NONE} all
		end

	EL_CURL_INFO_CONSTANTS
		export
			{NONE} all
		end

	CURL_FORM_CONSTANTS
		rename
			is_valid as is_valid_form_constant
		export
			{NONE} all
		end

	EL_STRING_8_CONSTANTS

	EL_SHARED_CURL_API; EL_SHARED_HTTP_STATUS

	EL_SHARED_PROGRESS_LISTENER

feature {NONE} -- Constants

	Image_types: EL_STRING_8_LIST
		once
			Result := "gif, png, jpeg"
		end

	Mime: TUPLE [image, text: STRING]
		once
			create Result
			Tuple.fill (Result, "image/, text/")
		end

	Max_post_data_count: INTEGER = 1024

end