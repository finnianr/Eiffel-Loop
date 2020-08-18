note
	description: "Progress meter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-18 12:19:27 GMT (Tuesday 18th August 2020)"
	revision: "1"

class
	EL_PROGRESS_METER

inherit
	EL_HORIZONTAL_BOX
		rename
			make as make_box
		export
			{NONE} all
		end

	EL_MODULE_COLOR

	EL_MODULE_GUI

	EL_MODULE_VISION_2

	EL_MODULE_ZSTRING

	EL_STRING_8_CONSTANTS

	EL_MODULE_DEFERRED_LOCALE

	EL_PROGRESS_DISPLAY undefine copy, default_create, is_equal end

create
	make

feature {NONE} -- Initialization

	make (bar_width_cms, bar_height_cms: REAL; text_font: EV_FONT)
		local
			framed_bar: EV_FRAME
		do
			create bar.make_size (bar_width_cms, bar_height_cms)
			create framed_bar
			framed_bar.extend (bar)
			framed_bar.set_style (GUI.Ev_frame_raised)
			framed_bar.set_border_width (2)

			create label
			label.set_font (text_font)
			create label_right.make_with_text (new_percentage (0))
			label_right.set_font (text_font)
			completion_text := Empty_string_8
			make_unexpanded (0, 0.1, <<
				label,
				Vision_2.new_vertical_centered_box (0, 0, << framed_bar >>),
				label_right
			>>)
		end

feature -- Access

	completion_text: READABLE_STRING_GENERAL

	label: EL_LABEL

	text: READABLE_STRING_GENERAL

feature -- Element change

	set_completion_text (a_completion_text: like completion_text)
		do
			completion_text := a_completion_text
			set_minimum_width (width + GUI.string_width (final_text, label.font))
		end

feature -- Status change

	set_bar_color (a_color: EV_COLOR)
		do
			bar.set_foreground_color (a_color)
		end

	set_progress (proportion: DOUBLE)
		do
			label_right.set_text (new_percentage (proportion))
			bar.set_progress (proportion)
		end

feature {EL_PROGRESS_DISPLAY} -- Event handling

	on_finish
		do
			bar.on_finish
			label_right.set_text (final_text)
		end

	on_start (bytes_per_tick: INTEGER)
		do
			bar.on_start (bytes_per_tick)
		end

feature {NONE} -- Implementation

	set_identified_text (id: INTEGER; a_text: READABLE_STRING_GENERAL)
		do
		end

	final_text: READABLE_STRING_GENERAL
		do
			if completion_text.count > 0 then
				Result := Zstring.joined (' ', << new_percentage (1), completion_text >>)
			else
				Result := new_percentage (1)
			end
		end

	new_percentage (proportion: DOUBLE): STRING
		do
			Result := (proportion * 100).rounded.out + Percent_string
		end

feature {NONE} -- Internal attributes

	bar: EL_PROGRESS_BAR

	label_right: EL_LABEL

feature {NONE} -- Constants

	Percent_string: STRING = "%%"
end
