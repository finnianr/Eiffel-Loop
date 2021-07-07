note
	description: "Shared access to first created instance of object conforming to [$source EL_SUB_APPLICATION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-25 14:46:29 GMT (Friday 25th June 2021)"
	revision: "4"

deferred class
	EL_SHARED_SUB_APPLICATION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Sub_application: EL_SUB_APPLICATION
		once ("PROCESS")
			Result := create {EL_CONFORMING_SINGLETON [EL_SUB_APPLICATION]}
		end
end