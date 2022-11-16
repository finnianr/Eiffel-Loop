note
	description: "Developer class for code discovery/navigation purposes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_THREAD_DEVELOPER_CLASS

feature -- Code search routines

	frozen Previous_call_is_blocking_thread
			-- For use in development to find all thread blocks in code
		do
		end

	frozen Previous_call_is_thread_signal
			-- For use in development to find all thread signals in code
		do
		end

end