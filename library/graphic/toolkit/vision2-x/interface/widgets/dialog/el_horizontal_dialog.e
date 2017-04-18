note
	description: "Summary description for {EL_HORIZONTAL_DIALOG_2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-28 18:17:34 GMT (Saturday 28th January 2017)"
	revision: "2"

deferred class
	EL_HORIZONTAL_DIALOG

inherit
	EL_VERTICAL_DIALOG
		redefine
			new_outer_box, new_section_box, Box_separation_cms
		end

feature {NONE} -- Implementation

	new_outer_box: EL_BOX
		do
			create {EL_HORIZONTAL_BOX} Result.make_unexpanded (0, Box_separation_cms, new_box_section_list.to_array)
		end

	new_section_box (widgets: ARRAY [EV_WIDGET]; section_index: INTEGER): EL_VERTICAL_BOX
		do
			create Result.make_unexpanded (0, Widget_separation_cms, widgets)
		end

feature {NONE} -- Dimensions

	Box_separation_cms: REAL
		once
			Result := 0.5
		end

end
