note
	description: "Logged thread manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-08 8:55:56 GMT (Thursday 8th October 2020)"
	revision: "8"

class
	EL_LOGGED_THREAD_MANAGER

inherit
	EL_THREAD_MANAGER
		undefine
			new_lio
		redefine
			on_wait
		end

	EL_MODULE_LOG

create
	make

feature {NONE} -- Implementation

	on_wait (thread_name: STRING)
		do
			lio.put_labeled_string ("Waiting to stop thread", thread_name)
			lio.put_new_line
		end
end