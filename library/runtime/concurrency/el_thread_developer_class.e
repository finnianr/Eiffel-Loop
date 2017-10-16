note
	description: "Developer class for code discovery/navigation purposes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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