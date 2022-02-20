note
	description: "Logged function distributer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-20 15:30:01 GMT (Sunday 20th February 2022)"
	revision: "7"

class
	EL_LOGGED_FUNCTION_DISTRIBUTER [G]

inherit
	EL_FUNCTION_DISTRIBUTER [G]
		redefine
			threads
		end

create
	make, make_threads

feature {NONE} -- Internal attributes

	threads: EL_ARRAYED_LIST [EL_LOGGED_WORK_DISTRIBUTION_THREAD]
		-- threads of worker threads

end