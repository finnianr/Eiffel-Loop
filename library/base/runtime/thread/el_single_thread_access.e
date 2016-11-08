note
	description: "[
		mutex to restrict access to critical sections with descriptive routines
		`restrict_access' and `end_restriction'. Recommended use is through class inheritance.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-11-07 10:28:48 GMT (Monday 7th November 2016)"
	revision: "2"

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
