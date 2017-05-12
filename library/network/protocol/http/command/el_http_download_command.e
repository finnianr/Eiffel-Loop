note
	description: "Performs a http download using the connection `connection'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-11 11:53:58 GMT (Thursday 11th May 2017)"
	revision: "2"

deferred class
	EL_HTTP_DOWNLOAD_COMMAND

inherit
	EL_HTTP_COMMAND

	EL_SHARED_ONCE_STRINGS

feature {NONE} -- Implementation

	frozen on_data_transfer (c_string: POINTER; a_size, a_nmemb: INTEGER): INTEGER
		local
			string: like Once_string_8
		do
			string := empty_once_string_8
			string.from_c_substring (c_string, 1, a_size * a_nmemb)
			Result := string.count
			on_string_transfer (string)
			listener.on_notify (string.count)  -- progress notification
		end

	on_string_transfer (a_string: STRING)
		deferred
		end

	prepare (connection: EL_HTTP_CONNECTION)
		do
			connection.set_write_function (curl_on_data_transfer, pointer_to_c_callbacks_struct)
			connection.set_curl_boolean_option (CURLOPT_header, False)
			connection.set_cookies
		end

feature {NONE} -- Constants

	Call_back_routines: ARRAY [POINTER]
			-- redefine with addresses of frozen procedures
		once
			Result := << $on_data_transfer >>
		end

end
