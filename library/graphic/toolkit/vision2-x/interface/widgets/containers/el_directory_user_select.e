note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:20 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_DIRECTORY_USER_SELECT

inherit
	EV_HORIZONTAL_BOX

	EL_MODULE_PATH
		rename
			Path as Path_utf8,
			Path_latin1 as Path
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end

	EV_FONT_CONSTANTS
		undefine
			default_create, copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (default_directory: STRING; a_window: EV_WINDOW)
			--
		do
			default_create
			first_window := a_window
			create Directory_dialog
			Directory_dialog.ok_actions.extend (agent on_directory_selected)

			create directory_path.make_from_string (default_directory)

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

	directory_path: EL_DIR_PATH

feature {NONE} -- Handlers

	on_browse_selected
			--
		local
			l_path: EL_PATH_STEPS
			path_exists: BOOLEAN
			l_directory: DIRECTORY
			start_directory: EL_DIR_PATH
		do
			from
				l_path := Path.steps (directory_path)
			until
				path_exists or l_path.is_empty
			loop
				start_directory := Path.directory_name_from_steps (l_path)
				create l_directory.make (start_directory)
				path_exists := l_directory.exists
				l_path.finish
				l_path.remove
			end
			directory_dialog.set_start_directory (start_directory)
			directory_dialog.show_modal_to_window (first_window)
		end

	on_directory_selected
			--
		do
			create directory_path.make_from_string (Directory_dialog.directory)
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
