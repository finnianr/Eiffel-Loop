note
	description: "Text editor undo/redo test"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 15:13:33 GMT (Sunday 22nd September 2024)"
	revision: "2"

class
	TEXT_EDITOR_MAIN_WINDOW

inherit
	EL_TITLED_WINDOW
		redefine
			create_interface_objects, initialize, make
		end

	EL_MODULE_COLOR; EL_MODULE_VISION_2

	EL_KEYBOARD_ACCELERATED

create
	make

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			initialize_accelerators
			put (Vision_2.new_horizontal_box (0.5, 0, << editor >>))
		end

	make
		do
			Precursor
			set_title ("Editor Window")
		end

feature {NONE} -- Factory

	new_accelerator_table (ev: EV_KEY_CONSTANTS): like default_accelerator_table
		-- table of key codes and left-shifted modifiers mapped to procedures
		-- using `single' or `combination' to create key
		do
			create Result.make_assignments (<<
				[combined (Ctrl, ev.Key_z), agent editor.undo],
				[combined (Ctrl, ev.Key_y), agent editor.redo]
			>>)
		end

feature {NONE} -- Implementation

	create_interface_objects
		local
			edit_font: EL_FONT
		do
			Precursor
			create editor
			create edit_font.make_regular ("Droid Sans", 0.5)
			editor.set_font (edit_font)
			editor.set_background_color (Color.text_field_background)
			editor.set_minimum_size (edit_font.width * 100, edit_font.line_height *20)
			editor.enable_undo
			editor.enable_word_wrapping
		end

feature {NONE} -- Internal attributes

	editor: EL_TEXT

end