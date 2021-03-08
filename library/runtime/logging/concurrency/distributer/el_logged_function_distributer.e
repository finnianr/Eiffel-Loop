note
	description: "Logged function distributer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-08 14:41:43 GMT (Monday 8th March 2021)"
	revision: "6"

class
	EL_LOGGED_FUNCTION_DISTRIBUTER [G]

inherit
	EL_FUNCTION_DISTRIBUTER [G]
		redefine
			threads
		end

create
	make

feature {NONE} -- Internal attributes

	threads: EL_ARRAYED_LIST [EL_LOGGED_WORK_DISTRIBUTION_THREAD]
		-- threads of worker threads

end