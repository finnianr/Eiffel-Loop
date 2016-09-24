note
	description: "Performs a data transfer using the http connection `connection'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-09-21 9:40:21 GMT (Wednesday 21st September 2016)"
	revision: "1"

deferred class
	EL_HTTP_COMMAND

inherit
	EL_COMMAND

	EL_C_CALLABLE
		rename
			make as make_default
		end

	EL_CURL_OPTION_CONSTANTS
		rename
			is_valid as is_valid_option_constant
		export
			{NONE} all
		end

	EL_SHARED_FILE_PROGRESS_LISTENER

feature {NONE} -- Initialization

	make (a_connection: like connection)
		do
			make_default
			connection := a_connection
			connection.set_curl_option_with_data (callback_curl_option, callback_address)
			listener := progress_listener
		end

feature -- Basic operations

	execute
		do
			reset
			protect_c_callbacks
			connection.set_curl_option_with_data (callback_curl_data_option, pointer_to_c_callbacks_struct)
			connection.do_transfer
			unprotect_c_callbacks
		end

feature {NONE} -- Implementation

	callback_curl_option: INTEGER
		do
			Result := CURLOPT_writefunction
		end

	callback_curl_data_option: INTEGER
		do
			Result := CURLOPT_writedata
		end

	callback_address: POINTER
		deferred
		end

	reset
		do
		end

feature {NONE} -- Internal attributes

	connection: EL_HTTP_CONNECTION

	listener: EL_FILE_PROGRESS_LISTENER
		-- progress listener

end
