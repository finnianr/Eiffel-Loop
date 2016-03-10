note
	description: "Summary description for {RADIO_OPTIONS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "6"

deferred class
	EL_RADIO_BUTTON_GROUP [G]

inherit
	EL_INPUT_WIDGET [G]

feature {NONE} -- Initialization

	make_widget (a_initialization_tuples: like initialization_tuples)
		do
			create buttons.make (a_initialization_tuples.count)
			across a_initialization_tuples as tuple loop
				buttons.extend (
					create {EV_RADIO_BUTTON}.make_with_text_and_action (
						tuple.item.displayed_value, agent do_change_action (tuple.item.value)
					)
				)
				if tuple.item.is_current_value then
					selected_index := buttons.count
				end
			end
		end

feature -- Access

	horizontal_box (a_border_cms, a_padding_cms: REAL): EL_HORIZONTAL_BOX
		do
			Result := GUI.horizontal_box (a_border_cms, a_padding_cms, buttons.to_array)
			set_selected
		end

	vertical_box (a_border_cms, a_padding_cms: REAL): EL_VERTICAL_BOX
		do
			Result := GUI.vertical_box (a_border_cms, a_padding_cms, buttons.to_array)
			set_selected
		end

	table (rows, cols: INTEGER; a_border_cms, a_padding_cms: REAL): EV_TABLE
		do
			create Result
			Result.set_border_width (Screen.vertical_pixels (a_border_cms))
			Result.disable_homogeneous
			Result.set_row_spacing (Screen.vertical_pixels (a_padding_cms))
			Result.set_column_spacing (Screen.horizontal_pixels (a_padding_cms))
			set_table_items (Result, rows, cols)
			set_selected
		end

	buttons: ARRAYED_LIST [EV_RADIO_BUTTON]

feature -- Status change

	set_selected
		do
			if selected_index > 0 then
				buttons.go_i_th (selected_index)
				buttons.item.select_actions.block
				buttons.item.enable_select
				buttons.item.select_actions.resume
			end
		end

feature {NONE} -- Implementation

	set_table_items (a_table: EV_TABLE; rows, cols: INTEGER)
		local
			row, column, i: INTEGER
		do
			a_table.resize (cols, rows)
			across buttons as button loop
				i := button.cursor_index
				column := (i - 1) \\ cols + 1; row := (i - 1) // cols + 1
				a_table.put_at_position (button.item, column, row, 1, 1)
			end
		end

	selected_index: INTEGER

end
