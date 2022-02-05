note
	description: "Shared instance of object conforming to [$source EL_APPLICATION_COMMAND_OPTIONS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 15:15:59 GMT (Saturday 5th February 2022)"
	revision: "2"

deferred class
	EL_SHARED_APPLICATION_OPTION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	frozen App_option: EL_APPLICATION_COMMAND_OPTIONS
		once ("PROCESS")
			Result := create {EL_CONFORMING_SINGLETON [EL_APPLICATION_COMMAND_OPTIONS]}
		end
end