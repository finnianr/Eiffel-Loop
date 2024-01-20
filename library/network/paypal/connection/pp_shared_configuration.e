note
	description: "Shared access to first created instance of ${PP_CONFIGURATION}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "7"

deferred class
	PP_SHARED_CONFIGURATION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Configuration: PP_CONFIGURATION
		once ("PROCESS")
			Result := create {EL_SINGLETON [PP_CONFIGURATION]}
		end
end