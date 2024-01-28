note
	description: "Adds keyboard shortcuts to ${EV_WINDOW}.accelerators"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-28 15:39:25 GMT (Sunday 28th January 2024)"
	revision: "7"

class
	EL_KEYBOARD_SHORTCUTS

inherit
	ANY

	EL_KEYBOARD_ACCELERATED
		rename
			new_accelerator_table as default_accelerator_table
		end

create
	make, make_from_list

feature {NONE} -- Initialization

	make (a_window: EV_WINDOW)
			--
		do
			make_from_list (a_window.accelerators)
		end

	make_from_list (list: EV_ACCELERATOR_LIST)
			--
		do
			accelerators := list
		end

feature -- Element change

	extend (modifiers: NATURAL; key_code: INTEGER; action: PROCEDURE)
		do
			add_accelerator_action (combined (modifiers, key_code), action)
		end

	remove_last
		do
			accelerators.finish
			if not accelerators.off then
				accelerators.remove
			end
		end

feature {NONE} -- Internal attributes

	accelerators: EV_ACCELERATOR_LIST

end