note
	description: "A5 paper installer box"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-23 11:54:01 GMT (Saturday 23rd October 2021)"
	revision: "7"

class
	EL_A5_PAPER_INSTALLER_BOX

inherit
	EL_INSTALLER_BOX
		rename
			make as make_installer_box
		end

	EL_MODULE_BUILD_INFO

	EL_SHARED_WORD

create
	make

feature {NONE} -- Initialization

	make (a_dialog: like dialog)
		local
			l_font: EV_FONT; w: INTEGER
		do
			make_installer_box (a_dialog, 0.7, 0)
			next_button := new_button (Word.next, agent dialog.on_next)
			text_area := new_text_area

			extend (text_area)
			append_unexpanded (<< new_button_box >>)

			l_font := Vision_2.new_font_regular ("Courier 10 Pitch", 0.5)
			w := l_font.string_width ("0")
		end

feature -- Access

	next_button: EV_BUTTON

	text_area: like new_text_area

feature {NONE} -- Factory

	new_button_box: EL_HORIZONTAL_BOX
		do
			create Result.make_unexpanded (0, 0.3, <<
				Vision_2.new_label_with_font ("Version: " + Build_info.version.out, new_font (Size.tiny)),
				create {EL_EXPANDED_CELL}, next_button, cancel_button
			>>)
		end

	new_text_area: EL_A5_PAPER_TEXT_DRAWING_AREA
		do
			create Result.make
		end

end