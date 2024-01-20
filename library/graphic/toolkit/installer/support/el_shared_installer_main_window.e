note
	description: "Shared access to instance of object conforming to ${EL_INSTALLER_MAIN_WINDOW}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "3"

deferred class
	EL_SHARED_INSTALLER_MAIN_WINDOW

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Main: EL_INSTALLER_MAIN_WINDOW
		once ("PROCESS")
			Result := create {EL_CONFORMING_SINGLETON [EL_INSTALLER_MAIN_WINDOW]}
		end
end