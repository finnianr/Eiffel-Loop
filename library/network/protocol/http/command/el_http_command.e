note
	description: "Performs a data transfer using the http connection `connection'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-09-29 15:54:03 GMT (Thursday 29th September 2016)"
	revision: "3"

deferred class
	EL_HTTP_COMMAND

inherit
	EL_C_CALLABLE
		redefine
			make
		end

	EL_CURL_OPTION_CONSTANTS
		rename
			is_valid as is_valid_option_constant
		export
			{NONE} all
		end

	EL_SHARED_FILE_PROGRESS_LISTENER

feature {NONE} -- Initialization

	make
		do
			Precursor
			listener := progress_listener
		end

feature -- Basic operations

	execute (connection: EL_HTTP_CONNECTION)
		local
			callback: like new_callback
		do
			reset
			callback := new_callback
			connection.set_curl_option_with_data (callback_curl_option, callback_address)
			connection.set_curl_option_with_data (callback_curl_data_option, pointer_to_c_callbacks_struct)
			connection.do_transfer
			callback.release
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

	listener: EL_FILE_PROGRESS_LISTENER
		-- progress listener

end
