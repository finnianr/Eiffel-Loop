note
	description: "Summary description for {EL_SINGLE_THREAD_ACCESS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-02 10:14:36 GMT (Saturday 2nd July 2016)"
	revision: "3"

class
	EL_SINGLE_THREAD_ACCESS

feature {NONE} -- Initialization

	make_default
			--
		do
			create mutex.make
		end

feature {NONE} -- Basic operations

	restrict_access
			-- restrict access to single thread at a time
		do
			mutex.lock
		end

	end_restriction
			-- end restricted thread access
		do
			mutex.unlock
		end

feature {NONE} -- Implementation

	mutex: MUTEX

end