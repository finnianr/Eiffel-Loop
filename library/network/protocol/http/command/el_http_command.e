note
	description: "Performs a data transfer using the http connection `connection'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-12 10:25:05 GMT (Friday 12th May 2017)"
	revision: "5"

deferred class
	EL_HTTP_COMMAND

inherit
	EL_C_CALLABLE
		rename
			make as make_callable
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
			make_callable
			connection := a_connection
			listener := progress_listener
		end

feature -- Basic operations

	execute
		local
			callback: like new_callback
		do
			reset
			callback := new_callback
			prepare
			connection.do_transfer
			callback.release
		end

feature {NONE} -- Implementation

	prepare
		deferred
		end

	reset
		do
		end

feature {NONE} -- Internal attributes

	connection: EL_HTTP_CONNECTION

	listener: EL_FILE_PROGRESS_LISTENER
		-- progress listener

feature {NONE} -- C externals

	curl_on_data_transfer: POINTER
		external
			"C [macro <el_curl.h>]: POINTER"
		alias
			"curl_on_data_transfer"
		end

	curl_on_do_nothing_transfer: POINTER
		external
			"C [macro <el_curl.h>]: POINTER"
		alias
			"curl_on_do_nothing_transfer"
		end

end
