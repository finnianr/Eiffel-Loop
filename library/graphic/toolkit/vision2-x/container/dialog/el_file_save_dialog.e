note
	description: "File save dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-20 14:10:12 GMT (Tuesday 20th August 2019)"
	revision: "3"

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

	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_name, description, extension: READABLE_STRING_GENERAL; a_last_saved_dir: EL_DIR_PATH; a_save: like save)
		local
			file_path: EL_FILE_PATH; name: ZSTRING
		do
			make_with_title ("Save as " + description)
			create filter_extensions.make (2)
			save := a_save; last_saved_dir := a_last_saved_dir
			add_filter (description, extension)
			create name.make_from_general (a_name)
			file_path := last_saved_dir + name
			if not file_path.has_extension (extension) then
				file_path.add_extension (extension)
			end
			set_full_file_path (file_path)
		end

feature -- Element change

	add_filter (description, extension: READABLE_STRING_GENERAL)
		local
			wild_card, l_extension, l_description: ZSTRING
		do
			create l_extension.make_from_general (extension)
			filter_extensions.extend (l_extension)
			filter_extensions.last.to_lower
			wild_card := "*."
			wild_card.append_string_general (extension)
			l_description := l_extension.as_upper + character_string (' ') + description
			filters.extend ([wild_card, Filter_template.substituted_tuple ([l_description, extension]).to_unicode])
		end

feature -- Access

	filter_extensions: EL_ZSTRING_LIST

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
			file_path: EL_FILE_PATH; extension, format_extension: ZSTRING
		do
			file_path := full_file_path; extension := file_path.extension.as_lower
			if filters.valid_index (selected_filter_index) then
				create format_extension.make_from_general (filters.i_th (selected_filter_index).filter)
				format_extension.remove_head (2)
				format_extension.to_lower
				if extension /~ format_extension then
					if filter_extensions.has (extension) then
						file_path := file_path.with_new_extension (format_extension)
					else
						file_path.add_extension (format_extension)
					end
				end
			end
			if file_path.exists then
				create dialog.make_with_text (Confirmation_template #$ [file_path.base])
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

	last_saved_dir: EL_DIR_PATH

	save: PROCEDURE [EL_FILE_PATH]

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
