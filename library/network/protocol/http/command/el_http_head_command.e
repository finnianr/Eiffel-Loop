note
	description: "[
		Performs a http HEAD request using the connection `connection' and stores
		the data in the string `string'. Windows style newlines ("%R%N") are converted to Unix style.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-11 12:00:13 GMT (Thursday 11th May 2017)"
	revision: "3"

class
	EL_HTTP_HEAD_COMMAND

inherit
	EL_HTTP_STRING_COMMAND
		redefine
			prepare
		end

create
	make

feature {NONE} -- Implementation

	prepare (connection: EL_HTTP_CONNECTION)
		do
			connection.set_write_function (curl_on_data_transfer, pointer_to_c_callbacks_struct)
			connection.set_curl_boolean_option (CURLOPT_header, True)
			connection.set_nobody (True)
		end

end
