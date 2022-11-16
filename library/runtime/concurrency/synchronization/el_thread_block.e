note
	description: "Thread block"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_THREAD_BLOCK

inherit
	EL_SINGLE_THREAD_ACCESS
		rename
			make_default as make
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			create condition.make
		end

feature -- Basic operations

	suspend
			--
		do
			wait_until (condition)
		end

	resume
			--
		do
			condition.signal
		end

feature {NONE} -- Implementation

	condition: CONDITION_VARIABLE

end