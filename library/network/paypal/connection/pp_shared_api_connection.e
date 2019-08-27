note
	description: "Shared instance of class [$source PP_NVP_API_CONNECTION]"
	notes: "[
		Before using `API_connection' be sure to initialize the configuration by creating an instance
		of class [$source PP_CONFIGURATION] somewhere in the application.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-27 12:45:17 GMT (Tuesday 27th August 2019)"
	revision: "1"

deferred class
	PP_SHARED_API_CONNECTION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	API_connection: PP_NVP_API_CONNECTION
		once ("PROCESS")
			create Result.make (API_version)
		end

	API_version: REAL
		once
			Result := 95.0
		end

end
