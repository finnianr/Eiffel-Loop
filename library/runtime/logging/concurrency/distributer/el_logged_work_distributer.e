note
	description: "Logged work distributer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-20 15:30:09 GMT (Sunday 20th February 2022)"
	revision: "7"

class
	EL_LOGGED_WORK_DISTRIBUTER [R -> ROUTINE]

inherit
	EL_WORK_DISTRIBUTER [R]
		redefine
			threads
		end

create
	make, make_threads

feature {NONE} -- Internal attributes

	threads: EL_ARRAYED_LIST [EL_LOGGED_WORK_DISTRIBUTION_THREAD]
		-- threads of worker threads

end