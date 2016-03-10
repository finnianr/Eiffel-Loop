note
	description: "Worker thread with logging output visible in console"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

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
