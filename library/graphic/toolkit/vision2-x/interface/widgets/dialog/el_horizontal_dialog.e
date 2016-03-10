note
	description: "Summary description for {EL_HORIZONTAL_DIALOG_2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "5"

deferred class
	EL_HORIZONTAL_DIALOG

inherit
	EL_VERTICAL_DIALOG
		redefine
			new_outer_box, new_inner_box, Box_separation_cms
		end

feature {NONE} -- Implementation

	new_outer_box: EL_BOX
		do
			create {EL_HORIZONTAL_BOX} Result.make (0, Box_separation_cms)
		end

	new_inner_box (widgets: ARRAY [EV_WIDGET]): EL_BOX
		do
			Result := GUI.vertical_box (0, Widget_separation_cms, widgets)
		end

feature {NONE} -- Dimensions

	Box_separation_cms: REAL
		once
			Result := 0.5
		end

end
