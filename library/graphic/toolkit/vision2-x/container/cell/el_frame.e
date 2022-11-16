note
	description: "Frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	EL_FRAME [B -> EL_BOX create make end]

inherit
	EV_FRAME
		rename
			extend as set_item,
 			make_with_text as make_frame_with_text
 		undefine
 			set_text
		redefine
			implementation
		end

	EL_TEXTABLE
		rename
 			make_with_text as make_frame_with_text
		undefine
			initialize, is_in_default_state
		redefine
			implementation
		end

	EL_MODULE_ACTION

	EL_MODULE_SCREEN

create
	default_create, make_with_text_and_widget, make_with_text, make

feature {NONE} -- Initialization

	make (a_border_cms, a_padding_cms: REAL)
			--
		do
			default_create
			create box.make (a_border_cms, a_padding_cms)
			set_item (box)
		end

	make_with_text (a_border_cms, a_padding_cms: REAL; a_text: READABLE_STRING_GENERAL)
			--
		do
			make (a_border_cms, a_padding_cms)
			if not a_text.is_empty then
				set_text (Bracket_template #$ [a_text])
			end
		end

	make_with_text_and_widget (a_border_cms, a_padding_cms: REAL; a_text: READABLE_STRING_GENERAL; a_widget: EV_WIDGET)
			--
		do
			make_with_text (a_border_cms, a_padding_cms, a_text)
			extend (a_widget)
		end

feature -- Element change

	extend (a_widget: EV_WIDGET)
			--
		do
			box.extend (a_widget)
		end

	extend_unexpanded (a_widget: EV_WIDGET)
			--
		do
			box.extend_unexpanded (a_widget)
		end

feature -- Status setting

	disable_last_item_expand
			--
		do
			box.disable_item_expand (box.last)
		end

	enable_last_item_expand
			--
		do
			box.enable_item_expand (box.last)
		end

	set_border_cms (a_value_cms: REAL)
		do
			set_border_width (Screen.horizontal_pixels (a_value_cms))
		end

	set_padding_width, set_padding (value: INTEGER)
			--
		do
			box.set_padding (value)
		end

feature -- Access

	box: B

feature {EV_ANY, EV_ANY_I} -- Implementation

	implementation: EV_FRAME_I
			-- Responsible for interaction with native graphics toolkit.

feature {NONE} -- Constants

	Bracket_template: ZSTRING
		once
			Result := " [ %S ] "
		end

end