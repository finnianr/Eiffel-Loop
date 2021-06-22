note
	description: "Shared access to first created instance of [$source PP_CONFIGURATION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-22 11:14:14 GMT (Tuesday 22nd June 2021)"
	revision: "5"

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