note
	description: "Worker thread with logging output visible in console"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_VISIBLE_WORKER_THREAD

inherit
	EL_WORKER_THREAD
		redefine
			is_visible_in_console
		end

create
	make

feature -- Status query

	is_visible_in_console: BOOLEAN = True

end
