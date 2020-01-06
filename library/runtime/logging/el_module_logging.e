note
	description: "Shared instance of [$source EL_GLOBAL_LOGGING] as `Logging'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-06 8:58:35 GMT (Monday 6th January 2020)"
	revision: "10"

deferred class
	EL_MODULE_LOGGING

inherit
	EL_MODULE

feature {NONE} -- Constants

	Logging: EL_GLOBAL_LOGGING
		--	
		once ("PROCESS")
			Result := (create {EL_SINGLETON [EL_GLOBAL_LOGGING]}).singleton
		end

end
