note
	description: "Shared access to first created instance of object conforming to ${EL_APPLICATION}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "8"

deferred class
	EL_SHARED_APPLICATION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Application: EL_APPLICATION
		-- Currently running application
		once ("PROCESS")
			Result := create {EL_CONFORMING_SINGLETON [EL_APPLICATION]}
		end
end