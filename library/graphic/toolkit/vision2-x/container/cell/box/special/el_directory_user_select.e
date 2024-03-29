note
	description: "Directory user select"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	EL_DIRECTORY_USER_SELECT

inherit
	EV_HORIZONTAL_BOX

	EV_FONT_CONSTANTS
		undefine
			default_create, copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (default_directory: DIR_PATH; a_window: EV_WINDOW)
			--
		do
			default_create
			first_window := a_window
			create Directory_dialog
			Directory_dialog.ok_actions.extend (agent on_directory_selected)

			directory_path := default_directory

			create button.make_with_text ("Browse...")
			button.select_actions.force_extend (agent on_browse_selected)
			button.set_font (Text_font)

			create text_field.make_with_text (directory_path)
			text_field.set_font (Text_font)

			extend (text_field)
			last.set_minimum_width (500)
			extend (button)
--			set_border_width (10)
			set_padding_width (10)
		end

feature -- Access

	directory_path: DIR_PATH

feature {NONE} -- Handlers

	on_browse_selected
			--
		local
			path_steps: EL_PATH_STEPS; start_directory: DIR_PATH
			path_exists: BOOLEAN; l_directory: DIRECTORY
		do
			from
				path_steps := directory_path.twin
			until
				path_exists or path_steps.is_empty
			loop
				start_directory := path_steps
				create l_directory.make (start_directory)
				path_exists := l_directory.exists
				path_steps.remove_tail (1)
			end
			directory_dialog.set_start_directory (start_directory)
			directory_dialog.show_modal_to_window (first_window)
		end

	on_directory_selected
			--
		do
			directory_path := Directory_dialog.directory
			text_field.set_text (directory_path)
		end

feature {NONE} -- Implementation

	first_window: EV_WINDOW

	button: EV_BUTTON

	text_field: EV_TEXT_FIELD

	directory_dialog: EV_DIRECTORY_DIALOG

feature {NONE} -- Constants

	Text_font: EV_FONT
			--
		do
			create Result.make_with_values (Family_sans, Weight_regular, Shape_regular, 14)
		end

end