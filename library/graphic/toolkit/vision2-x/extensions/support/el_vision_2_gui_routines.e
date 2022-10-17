note
	description: "[
		Vision 2 giving access to various shared objects and routines related to
		
		* Fonts and font string measurement
		* Word wrapping
		* Color code conversion
		* Action management
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-17 14:01:54 GMT (Monday 17th October 2022)"
	revision: "38"

class
	EL_VISION_2_GUI_ROUTINES

inherit
	EV_SHARED_APPLICATION
		export
			{NONE} process_events_and_idle
		end

	EL_MODULE_REUSEABLE

	EL_SHARED_DEFAULT_PIXMAPS

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			application := ev_application
			create timer_list.make (3)
		end

feature -- Access

	application: EV_APPLICATION

feature -- Action management

	block_all (actions: ARRAY [ACTION_SEQUENCE])
		do
			across actions as a loop
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
			application.do_once_on_idle (an_action)
		end

	resume_all (actions: ARRAY [ACTION_SEQUENCE])
		do
			actions.do_all (agent {ACTION_SEQUENCE}.resume)
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