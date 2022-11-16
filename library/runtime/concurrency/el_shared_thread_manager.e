note
	description: "Shared thread manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

deferred class
	EL_SHARED_THREAD_MANAGER

inherit
	EL_ANY_SHARED

feature {NONE} -- Constant

	Thread_manager: EL_THREAD_MANAGER
			--
		once ("PROCESS")
			Result := create {EL_CONFORMING_SINGLETON [EL_THREAD_MANAGER]}
		end

end