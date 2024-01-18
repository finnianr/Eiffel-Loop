note
	description: "Shared access to instance of ${EL_ISE_PATH_MANGER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-04 9:25:17 GMT (Saturday 4th November 2023)"
	revision: "1"

deferred class
	EL_SHARED_PATH_MANAGER

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Path_manager: EL_ISE_PATH_MANGER
			--
		once
			create Result
		end

end