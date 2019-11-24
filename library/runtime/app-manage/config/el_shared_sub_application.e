note
	description: "Shared application option name"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-24 12:08:02 GMT (Sunday 24th November 2019)"
	revision: "3"

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
