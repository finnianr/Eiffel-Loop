note
	description: "Shared instance of ${EL_INSTALL_UNINSTALL_TESTER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-08 9:59:48 GMT (Saturday 8th July 2023)"
	revision: "1"

deferred class
	EL_SHARED_INSTALL_UNINSTALL_TESTER

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Test_aware: EL_INSTALL_UNINSTALL_TESTER
		once
			create Result
		end
end