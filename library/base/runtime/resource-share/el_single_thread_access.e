note
	description: "[
		mutex to restrict access to critical sections with descriptive routines
		`restrict_access' and `end_restriction'. Recommended use is through class inheritance.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	EL_SINGLE_THREAD_ACCESS

feature {NONE} -- Initialization

	make_default
			--
		do
			create mutex.make
		end

feature -- Status query

	is_restricted: BOOLEAN
		do
			Result := mutex.owner /= default_pointer
		end

feature -- Status change

	end_restriction
			-- end restricted thread access
		do
			mutex.unlock
		end

	restrict_access
			-- restrict access to single thread at a time
		do
			mutex.lock
		end

feature -- Basic operations

	wait_until (condition: CONDITION_VARIABLE)
		do
			restrict_access
				wait_until_signaled (condition)
			end_restriction
		end

	wait_until_signaled (condition: CONDITION_VARIABLE)
		do
			condition.wait (mutex)
		end

feature {NONE} -- Implementation

	mutex: MUTEX

end