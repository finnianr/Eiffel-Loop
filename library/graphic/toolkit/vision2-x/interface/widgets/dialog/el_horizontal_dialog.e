note
	description: "Horizontal dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "4"

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
