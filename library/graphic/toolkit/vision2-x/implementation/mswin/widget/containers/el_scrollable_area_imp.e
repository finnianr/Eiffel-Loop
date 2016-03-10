note
	description: "Summary description for {EL_SCROLLABLE_AREA_IMP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-28 9:19:47 GMT (Tuesday 28th May 2013)"
	revision: "2"

class
	EL_SCROLLABLE_AREA_IMP

inherit
	EL_SCROLLABLE_AREA_I
		undefine
			propagate_foreground_color, propagate_background_color, set_offset
		redefine
			interface, replace
		end

	EV_SCROLLABLE_AREA_IMP
		redefine
			interface, replace, on_mouse_wheel, accelerator_from_key_code
		end

create
	make

feature -- Element change

	replace (v: like item)
			-- Replace `item' with `v'.
		do
			Precursor (v)
			relay_focus_to_parent
		end

feature {EL_SCROLLABLE_AREA_IMP} -- Event handlers

	on_mouse_wheel (delta, keys, x_pos, y_pos: INTEGER)
			-- User moved mouse wheel.
		local
			step: INTEGER
		do
			if item.height > height then
				step := vertical_step * 3
				if delta // 120 >= 1 then
					set_y_offset ((y_offset - step).max (0))
				else
					set_y_offset ((y_offset + step).min (item.height - height))
				end
			end
		end

feature {EV_ANY, EV_ANY_I} -- Implementation		

	relay_focus_to_parent
			--
		do
			item.focus_in_actions.wipe_out
			if attached {EV_CONTAINER} item as container then
				take_focus_from_children (container)
			end
			item.pointer_button_press_actions.extend (agent on_pointer_button_press)
		end

	accelerator_from_key_code (a_key_code: INTEGER): EV_ACCELERATOR
			-- Keyboard shortcuts for Windows scrollable areas.
			-- The Vision2 gtk implementation provides this functionality by default

		local
			l_app: like application_imp
		do
			l_app := application_imp
			if item.height <= height or else l_app.ctrl_pressed or else l_app.alt_pressed or else l_app.shift_pressed then
				Result := Precursor (a_key_code)
			else
				inspect a_key_code
					when {EV_KEY_CONSTANTS}.Key_page_up then
						set_y_offset ((y_offset - (height * 0.9).rounded).max (0))

					when {EV_KEY_CONSTANTS}.Key_page_down then
						set_y_offset ((y_offset + (height * 0.9).rounded).min (item.height - height))

					when {EV_KEY_CONSTANTS}.Key_home then
						set_y_offset (0)

					when {EV_KEY_CONSTANTS}.Key_end then
						set_y_offset ((item.height - height).max (0))
				else
					Result := Precursor (a_key_code)
				end
			end
		end

	take_focus_from_children (a_container: EV_CONTAINER)
			-- recursively take focus from child widgets and lists if widget receives a
			-- mouse right click
		local
			l_list: LINEAR [EV_WIDGET]
		do
			l_list := a_container.linear_representation
			from l_list.start until l_list.after loop
				if attached {EV_CONTAINER} l_list.item as nested_list then
					nested_list.pointer_button_press_actions.extend (agent on_pointer_button_press)
					take_focus_from_children (nested_list)

				elseif attached {EV_BUTTON} l_list.item as button then
					-- This weird stuff is needed because taking away the focus away from a button
					-- prevents the normal select actions from working

					l_list.item.focus_in_actions.extend (
						agent (a_button: EV_BUTTON)
							do
								set_focus
								a_button.select_actions.call ([])

							end (button)
					)

				else
					l_list.item.focus_in_actions.extend (agent set_focus)
				end
				l_list.forth
			end
		end

	on_pointer_button_press (
		a_x: INTEGER; a_y: INTEGER; a_button: INTEGER
		a_x_tilt: DOUBLE; a_y_tilt: DOUBLE; a_pressure: DOUBLE; a_screen_x: INTEGER; a_screen_y: INTEGER
	)
			--
		do
			if a_button = 1 then
				set_focus
			end
		end

	interface: detachable EV_SCROLLABLE_AREA note option: stable attribute end;

end
