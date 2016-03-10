note
	description: "Summary description for {EL_THUMBNAIL_RADIO_BUTTON_GROUP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-26 11:24:43 GMT (Saturday 26th December 2015)"
	revision: "7"

class
	EL_THUMBNAIL_RADIO_BUTTON_GROUP

inherit
	EL_RADIO_BUTTON_GROUP [ZSTRING]
		rename
			make as make_button_group,
			default_sort_order as alphabetical_sort_order
		export
			{NONE} horizontal_box, vertical_box
		redefine
			set_table_items
		end

create
	make

feature {NONE} -- Initialization

	make (
		initial_value: ZSTRING; values: INDEXABLE [ZSTRING, INTEGER]; a_thumbnails: like thumbnails
		a_value_change_action: like value_change_action
	)
		do
			make_button_group (initial_value, values, a_value_change_action)
			thumbnails := a_thumbnails
			create previous_color
		end

feature -- Access

	horizontal_table (a_border_cms, a_padding_cms: REAL): EV_TABLE
		do
			Result := table (1, buttons.count, a_border_cms, a_padding_cms)
		end

	vertical_table (a_border_cms, a_padding_cms: REAL): EV_TABLE
		do
			Result := table (buttons.count, 1, a_border_cms, a_padding_cms)
		end

feature {NONE} -- Event Handlers

	on_enter (a_box: EL_HORIZONTAL_BOX; a_button: EV_RADIO_BUTTON)
		do
			previous_color := a_box.background_color
			a_box.set_background_color (Highlight_color)
			a_button.set_background_color (Highlight_color)
		end

	on_leave (a_box: EL_HORIZONTAL_BOX; a_button: EV_RADIO_BUTTON)
		do
			if a_box.background_color.rgb_24_bit = Highlight_color.rgb_24_bit then
				a_box.set_background_color (previous_color)
				a_button.set_background_color (previous_color)
			end
		end

feature {NONE} -- Implementation

	set_table_items (a_table: EV_TABLE; rows, cols: INTEGER)
		local
			row, column, i: INTEGER
			l_box: EL_HORIZONTAL_BOX
			pixmap: EL_PIXMAP
		do
			a_table.resize (cols * 2, rows)
			across buttons as button loop
				i := button.cursor_index
				pixmap := thumbnails [i]
				column := (i - 1) \\ cols * 2 + 1; row := (i - 1) // cols + 1
				create l_box.make (0.07, 0)
				l_box.extend (pixmap)
				a_table.put_at_position (l_box, column, row, 1, 1)
				a_table.put_at_position (button.item, column + 1, row, 1, 1)

				set_highlight_actions (pixmap, l_box, button.item)
				set_highlight_actions (button.item, l_box, button.item)
				pixmap.pointer_button_press_actions.force_extend (agent (button.item).enable_select)
			end
		end

	set_highlight_actions (a_widget: EV_WIDGET; a_box: EL_HORIZONTAL_BOX; a_button: EV_RADIO_BUTTON)
		do
			a_widget.pointer_enter_actions.extend (agent on_enter (a_box, a_button))
			a_widget.pointer_leave_actions.extend (agent on_leave (a_box, a_button))
		end

	displayed_value (string: ZSTRING): ZSTRING
		do
			create Result.make_empty
		end

	thumbnails: ARRAYED_LIST [EL_PIXMAP]

	previous_color: EV_COLOR

feature {NONE} -- Constants

	Highlight_color: EV_COLOR
		once
			Result := GUI.Green
		end

end
