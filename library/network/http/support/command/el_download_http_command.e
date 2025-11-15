note
	description: "Performs a http download using the connection `connection'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-15 15:06:41 GMT (Saturday 15th November 2025)"
	revision: "8"

deferred class
	EL_DOWNLOAD_HTTP_COMMAND

inherit
	EL_HTTP_COMMAND

feature {NONE} -- Implementation

	frozen on_data_transfer (c_string: POINTER; a_size, a_nmemb: INTEGER): INTEGER
		local
			string: like Buffer
		do
			string := Buffer
			string.from_c_substring (c_string, 1, a_size * a_nmemb)
			Result := string.count
			on_string_transfer (string)
			listener.on_notify (string.count) -- progress notification
		end

	on_string_transfer (a_string: STRING)
		deferred
		end

	prepare
		do
			curl.set_write_function (curl_on_data_transfer, pointer_to_c_callbacks_struct)
			curl.set_boolean_option (CURLOPT_header, False)
			connection.set_cookie_options
		end

feature {NONE} -- Constants

	Buffer: STRING
		once
			create Result.make (50)
		end

	Call_back_routines: ARRAY [POINTER]
			-- redefine with addresses of frozen procedures
		once
			Result := << $on_data_transfer >>
		end

end