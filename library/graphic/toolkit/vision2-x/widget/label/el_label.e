note
	description: "Label"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-17 18:24:54 GMT (Monday 17th October 2022)"
	revision: "14"

class
	EL_LABEL

inherit
	EV_LABEL
		undefine
			set_text
		redefine
			implementation
		end

	EL_TEXTABLE
		undefine
			initialize, is_in_default_state
		redefine
			implementation
		end

	EL_MODULE_ACTION; EL_MODULE_COLOR

	EL_MODULE_TEXT
		rename
			Text as Rendered
		end

create
	default_create, make_with_text

feature -- Basic operations

	restore_later (seconds: REAL)
		-- restore `foreground_color' and `text' in elapsed `seconds'
		do
			Action.do_later ((seconds * 1000).rounded, agent set_color_and_text (foreground_color, text))
		end

feature -- Status change

	set_bold
		local
			bold: EV_FONT
		do
			bold := font
			bold.set_weight (Rendered.Weight_bold)
			set_font (bold)
		end

	set_italic
		local
			italic: EV_FONT
		do
			italic := font
			italic.set_shape (Rendered.Shape_italic)
			set_font (italic)
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	implementation: EV_LABEL_I
			-- Responsible for interaction with native graphics toolkit.

	set_color_and_text (a_color: EV_COLOR; a_text: READABLE_STRING_GENERAL)
		do
			set_foreground_color (a_color)
			set_text (a_text)
		end

end