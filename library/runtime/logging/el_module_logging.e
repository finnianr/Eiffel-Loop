note
	description: "Shared instance of [$source EL_GLOBAL_LOGGING] as `Logging'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-17 9:29:25 GMT (Sunday 17th May 2020)"
	revision: "11"

deferred class
	EL_MODULE_LOGGING

inherit
	EL_MODULE

feature {NONE} -- Constants

	Logging: EL_GLOBAL_LOGGING
		--	
		once ("PROCESS")
			Result := create {EL_SINGLETON [EL_GLOBAL_LOGGING]}
		end

end
