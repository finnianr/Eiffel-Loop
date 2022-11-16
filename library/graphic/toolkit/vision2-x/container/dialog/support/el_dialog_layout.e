note
	description: "Dialog layout info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_DIALOG_LAYOUT

inherit
	EV_TEXT_ALIGNMENT_CONSTANTS
		export
			{NONE} all
			{ANY} valid_alignment
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create paragraph
			paragraph.alignment := Ev_text_alignment_left
			paragraph.separation_cms := 0.3
			paragraph.width_cms := 15.5

			create progress_meter
			progress_meter.bar_width_cms := 5.0
			progress_meter.bar_height_cms := 0.1

			border_inner_width_cms := 0.35
			box_separation_cms := 0.3
			dialog_border_width_cms := 0.11
			row_separation_cms := 0.3
			button_separation_cms := 0.4

			buttons_right_aligned := True
		end

feature -- Element change

	set_border_inner_width_cms (a_border_inner_width_cms: REAL)
		do
			border_inner_width_cms := a_border_inner_width_cms
		end

	set_box_separation_cms (a_box_separation_cms: REAL)
		do
			box_separation_cms := a_box_separation_cms
		end

	set_button_separation_cms (a_button_separation_cms: REAL)
		do
			button_separation_cms := a_button_separation_cms
		end

	set_dialog_border_width_cms (a_dialog_border_width_cms: REAL)
		do
			dialog_border_width_cms := a_dialog_border_width_cms
		end

	set_paragraph_alignment (alignment: INTEGER)
		require
			valid_alignment: valid_alignment (alignment)
		do
			paragraph.alignment := alignment
		end

	set_row_separation_cms (a_row_separation_cms: like row_separation_cms)
		do
			row_separation_cms := a_row_separation_cms
		end

feature -- Dimensions

	border_inner_width_cms: REAL

	box_separation_cms: REAL

	button_separation_cms: REAL

	dialog_border_width_cms: REAL

	row_separation_cms: REAL
		-- separation of component rows

feature -- Access

	paragraph: TUPLE [alignment: INTEGER; separation_cms, width_cms: REAL]

	progress_meter: TUPLE [bar_width_cms, bar_height_cms: REAL]

feature -- Status query

	buttons_left_aligned: BOOLEAN
		do
			Result := not buttons_right_aligned
		end

	buttons_right_aligned: BOOLEAN

feature -- Status change

	enable_left_aligned_buttons
		do
			buttons_right_aligned := False
		end
end