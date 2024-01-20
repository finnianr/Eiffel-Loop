note
	description: "[
		Shared access to first created instance of object conforming to ${PP_NVP_API_CONNECTION}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "4"

deferred class
	PP_SHARED_API_CONNECTION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	API_connection: PP_NVP_API_CONNECTION
		once ("PROCESS")
			Result := create {EL_CONFORMING_SINGLETON [PP_NVP_API_CONNECTION]}
		end

end