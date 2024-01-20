note
	description: "Action management routines accessible via ${EL_MODULE_ACTION}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "41"

class
	EL_ACTION_MANAGER

inherit
	EV_SHARED_APPLICATION
		export
			{NONE} all
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			--
		do
			create timer_list.make (3)
		end

feature -- Action management

	block_all (action_list: ITERABLE [ACTION_SEQUENCE])
		do
			across action_list as a loop
				a.item.flush
				a.item.block
			end
		end

	do_later (millisecs_interval: INTEGER_32; a_action: PROCEDURE)
		local
			timer: EV_TIMEOUT
		do
			create timer.make_with_interval (millisecs_interval)
			timer_list.extend (timer)
			timer.actions.extend (agent do_once_action (timer, a_action))
		end

	do_once_on_idle (an_action: PROCEDURE)
		do
			ev_application.do_once_on_idle (an_action)
		end

	resume_all (action_list: ITERABLE [ACTION_SEQUENCE [TUPLE]])
		do
			across action_list as a loop
				a.item.resume
			end
		end

feature {NONE} -- Implementation

	do_once_action (timer: EV_TIMEOUT; action: PROCEDURE)
		do
			timer.actions.block
			timer_list.prune (timer)
			action.apply
		end

feature {NONE} -- Internal attributes

	timer_list: ARRAYED_LIST [EV_TIMEOUT]

end