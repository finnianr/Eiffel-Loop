note
	description: "Performs a data transfer using the http connection `connection'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-11 11:48:59 GMT (Thursday 11th May 2017)"
	revision: "4"

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
			prepare (connection)
			connection.do_transfer
			callback.release
		end

feature {NONE} -- Implementation

	prepare (connection: EL_HTTP_CONNECTION)
		deferred
		end

	reset
		do
		end

feature {NONE} -- Internal attributes

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
