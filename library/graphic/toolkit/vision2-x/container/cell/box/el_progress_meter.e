note
	description: "Progress meter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-17 13:59:43 GMT (Monday 17th October 2022)"
	revision: "6"

class
	EL_PROGRESS_METER

inherit
	EL_HORIZONTAL_BOX
		rename
			make as make_box
		export
			{NONE} all
		end

	EL_MODULE_GUI; EL_MODULE_DEFERRED_LOCALE; EL_MODULE_VISION_2

	EL_MODULE_TEXT
		rename
			Text as Rendered
		end

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
			framed_bar.set_style (Vision_2.Frame_etched_in)
			framed_bar.set_border_width (2)


			create label
			label.set_font (text_font)
			create label_right.make_with_text (new_percentage (0))
			label_right.set_font (text_font)
			create {STRING} completion_text.make_empty
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
			set_minimum_width (width + Rendered.string_width (final_text, label.font))
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

	on_start (tick_byte_count: INTEGER)
		do
			bar.on_start (tick_byte_count)
		end

feature {NONE} -- Implementation

	set_identified_text (id: INTEGER; a_text: READABLE_STRING_GENERAL)
		do
		end

	final_text: READABLE_STRING_GENERAL
		do
			if completion_text.count > 0 then
				Result := new_percentage (1).joined ([' ', completion_text])
			else
				Result := new_percentage (1)
			end
		end

	new_percentage (proportion: DOUBLE): ZSTRING
		do
			create Result.make (20)
			Result.append_integer ((proportion * 100).rounded)
			Result.append_character ('%%')
		end

feature {NONE} -- Internal attributes

	bar: EL_PROGRESS_BAR

	label_right: EL_LABEL

end