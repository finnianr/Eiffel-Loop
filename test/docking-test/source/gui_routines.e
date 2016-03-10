note
	description: "Summary description for {GUI_ROUTINES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GUI_ROUTINES

inherit
	SHARED_CONSTANTS

feature -- Basic operations

	apply_cell_sandwich (box: EV_BOX)
		do
			box.put_front (create {EV_CELL})
			box.extend (create {EV_CELL})
		end

	do_once_on_idle (an_action: PROCEDURE [ANY, TUPLE])
		do
			Application.do_once_on_idle (an_action)
		end

feature -- Factory

	new_centered_horizontal_box (a_widget: EV_WIDGET): EV_HORIZONTAL_BOX
		do
			create Result
			Result.extend (a_widget)
			Result.disable_item_expand (a_widget)
			apply_cell_sandwich (Result)
		end

feature {NONE} -- Implementation

	Application: EV_APPLICATION
		once

		end

end
