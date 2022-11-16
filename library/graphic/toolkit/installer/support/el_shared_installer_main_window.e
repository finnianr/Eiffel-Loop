note
	description: "Shared access to instance of object conforming to [$source EL_INSTALLER_MAIN_WINDOW]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

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