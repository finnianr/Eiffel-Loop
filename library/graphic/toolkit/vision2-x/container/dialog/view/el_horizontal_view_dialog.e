note
	description: "Horizontal view dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-14 12:57:12 GMT (Friday 14th August 2020)"
	revision: "1"

deferred class
	EL_HORIZONTAL_VIEW_DIALOG

inherit
	EL_VIEW_DIALOG
		redefine
			new_outer_box, new_section_box
		end

feature {NONE} -- Implementation

	new_outer_box: EL_BOX
		do
			create {EL_HORIZONTAL_BOX} Result.make_unexpanded (
				0, model.layout.box_separation_cms, new_box_section_list.to_array
			)
		end

	new_section_box (widgets: ARRAY [EV_WIDGET]; section_index: INTEGER): EL_VERTICAL_BOX
		do
			create Result.make_unexpanded (0, model.layout.row_separation_cms, widgets)
		end

end
