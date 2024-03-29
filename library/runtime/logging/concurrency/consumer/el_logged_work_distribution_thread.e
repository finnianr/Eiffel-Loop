note
	description: "Logged work distribution thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	EL_LOGGED_WORK_DISTRIBUTION_THREAD

inherit
	EL_WORK_DISTRIBUTION_THREAD
		undefine
			on_start
		redefine
			execute, loop_action
		end

	EL_LOGGED_IDENTIFIED_THREAD
		undefine
			make_default, stop
		end

	EL_MODULE_EXCEPTION

create
	make

feature {NONE} -- Implementation

	execute
			-- Continuous loop to do action until stopped
		local
			log_stack_pos: INTEGER
		do
			log.enter (once "execute")
			log_stack_pos := log.call_stack_count
			from until is_stopping loop
				loop_action
			end
			log.exit
		rescue
			log.restore (log_stack_pos)
			log.exit
			Exception.put_last_trace (log)
			retry
		end

	loop_action
			--
		do
			log.enter (once "loop_action")
			routine.apply
			suspend
			log.exit
		end
end