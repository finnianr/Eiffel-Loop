note
	description: "File save dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-23 7:03:41 GMT (Tuesday 23rd July 2019)"
	revision: "2"

class
	EL_FILE_SAVE_DIALOG

inherit
	EV_FILE_SAVE_DIALOG
		rename
			set_position as set_absolute_position,
			set_x_position as set_absolute_x_position,
			set_y_position as set_absolute_y_position,
			file_path as file_path_string
		redefine
			show_modal_to_window
		end

	EL_ZSTRING_ROUTINES undefine default_create, copy end

	EL_WINDOW

	EL_MODULE_ZSTRING

	EL_MODULE_GUI

create
	make

feature {NONE} -- Initialization

	make (a_name, description, extension: READABLE_STRING_GENERAL; a_last_saved_dir: EL_DIR_PATH; a_save: like save)
		local
			file_path: EL_FILE_PATH; name: ZSTRING
			l_extension: READABLE_STRING_GENERAL
		do
			l_extension := to_unicode_general (extension)
			make_with_title ("Save " + description)
			save := a_save; last_saved_dir := a_last_saved_dir
			filters.extend (["*." + l_extension, Filter_template.substituted_tuple ([description, extension]).to_unicode])
			create name.make_from_general (a_name)
			file_path := last_saved_dir + name
			if not file_path.has_extension (extension) then
				file_path.add_extension (extension)
			end
			set_full_file_path (file_path)
		end

feature -- Status setting

	show_modal_to_window (a_window: EV_WINDOW)
		do
			save_actions.extend (agent on_save (a_window))
			Precursor (a_window)
		end

feature {NONE} -- Event handling

	on_save (a_window: EV_WINDOW)
		local
			dialog: EL_CONFIRMATION_DIALOG; confirmed: BOOLEAN
			file_path: EL_FILE_PATH
		do
			file_path := full_file_path
			if file_path.exists then
				create dialog.make_with_text (Confirmation_template.substituted_tuple ([file_path.base]).to_string_32)
				dialog.show_modal_to_window (a_window)
				confirmed := dialog.ok_selected
			else
				confirmed := True
			end
			if confirmed then
				last_saved_dir.set_path (file_path.parent)
				save (file_path)
			end
		end

feature {NONE} -- Internal attributes

	save: PROCEDURE [EL_FILE_PATH]

	last_saved_dir: EL_DIR_PATH

feature {NONE} -- Constants

	Confirmation_template: ZSTRING
		once
			Result := "[
				The file '#' already exists.
				Do you wish to overwrite it?
			]"
		end

	Filter_template: ZSTRING
		once
			Result := "%S (*.%S)"
		end
end
