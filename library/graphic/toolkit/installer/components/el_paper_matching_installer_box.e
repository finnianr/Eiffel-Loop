note
	description: "Installer box with A5/A4 paper sheet size matching"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-06 9:32:09 GMT (Thursday 6th July 2023)"
	revision: "10"

class
	EL_PAPER_MATCHING_INSTALLER_BOX

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

	make (a_dialog: like dialog; a_paper_code: NATURAL_8)
		local
			w: INTEGER
		do
			paper_code := a_paper_code
			make_installer_box (a_dialog, 0.7, 0)
			next_button := new_button (Word.next, agent dialog.on_next)
			text_area := new_text_area

			extend (text_area)
			append_unexpanded (<< new_button_box >>)

			if attached Vision_2.new_font_regular ("Courier 10 Pitch", 0.5) as l_font then
				w := l_font.string_width ("0")
			end
		end

feature -- Access

	next_button: EV_BUTTON

	text_area: like new_text_area

	paper_code: NATURAL_8

feature {NONE} -- Factory

	new_button_box: EL_HORIZONTAL_BOX
		do
			create Result.make_unexpanded (0, 0.3, <<
				Vision_2.new_label_with_font ("Version: " + Build_info.version.out, new_font (Size.tiny)),
				create {EL_EXPANDED_CELL}, next_button, cancel_button
			>>)
		end

	new_text_area: EL_PAPER_SHEET_DRAWING_AREA
		do
			create Result.make (paper_code)
		end

end