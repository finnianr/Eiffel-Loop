note
	description: "[
		Container for button with hidden progress bar that appears underneath button
		for actions that have a defined number of steps (ticks).
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-17 9:09:09 GMT (Wednesday 17th July 2019)"
	revision: "1"

class
	EL_BUTTON_PROGRESS_BOX [B -> EV_BUTTON create default_create end]

inherit
	EL_WIDGET_PROGRESS_BOX [B]
		rename
			widget as button
		end

create
	make, make_with_tick_count, make_default

feature {NONE} -- Initialization

	make_with_tick_count (a_button: B; tick_count: FUNCTION [INTEGER])
		-- swap select action of `a_button' with a progress trackable action
		require
			has_one_select_action: a_button.select_actions.count = 1
		do
			make (a_button)
			select_actions.finish
			if not select_actions.after then
				select_actions.replace (agent track_progress (select_actions.last, tick_count))
			end
		end

feature -- Access

	select_actions: EV_NOTIFY_ACTION_SEQUENCE
		do
			Result := button.select_actions
		end

feature -- Basic operations

	simulate_select
		do
			button.select_actions.call ([])
		end

end
