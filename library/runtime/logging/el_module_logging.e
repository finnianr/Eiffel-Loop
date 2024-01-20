note
	description: "Shared instance of ${EL_GLOBAL_LOGGING} as `Logging'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "13"

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