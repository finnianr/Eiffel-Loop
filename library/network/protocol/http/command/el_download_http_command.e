note
	description: "Performs a http download using the connection `connection'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-09-21 9:42:05 GMT (Wednesday 21st September 2016)"
	revision: "1"

deferred class
	EL_DOWNLOAD_HTTP_COMMAND

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

feature {NONE} -- C externals

	callback_address: POINTER
		external
			"C [macro <el_curl.h>]: POINTER"
		alias
			"curl_on_data_transfer"
		end

feature {NONE} -- Constants

	Call_back_routines: ARRAY [POINTER]
			-- redefine with addresses of frozen procedures
		once
			Result := << $on_data_transfer >>
		end

end
