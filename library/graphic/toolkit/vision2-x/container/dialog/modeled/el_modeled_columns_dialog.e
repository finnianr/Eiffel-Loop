note
	description: "Horizontal view dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

deferred class
	EL_MODELED_COLUMNS_DIALOG

inherit
	EL_MODELED_DIALOG
		rename
			new_outer_box as new_column_box
		redefine
			new_column_box, new_section_box
		end

feature {NONE} -- Implementation

	new_column_box: EL_HORIZONTAL_BOX
		do
			create Result.make_unexpanded (
				0, model.layout.box_separation_cms, new_box_section_list.to_array
			)
		end

	new_section_box (widgets: ARRAY [EV_WIDGET]; section_index: INTEGER): EL_VERTICAL_BOX
		do
			create Result.make_unexpanded (0, model.layout.row_separation_cms, widgets)
		end

end