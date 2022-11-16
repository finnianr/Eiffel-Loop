note
	description: "Logged procedure distributer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	EL_LOGGED_PROCEDURE_DISTRIBUTER [G]

inherit
	EL_PROCEDURE_DISTRIBUTER [G]
		redefine
			pool
		end

create
	make, make_threads

feature {NONE} -- Internal attributes

	pool: EL_ARRAYED_LIST [EL_LOGGED_WORK_DISTRIBUTION_THREAD]
		-- threads of worker threads

end