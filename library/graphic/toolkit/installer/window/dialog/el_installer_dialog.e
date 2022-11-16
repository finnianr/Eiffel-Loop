note
	description: "Installer dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_INSTALLER_DIALOG

inherit
	EL_UNTITLED_INSTALLER_DIALOG

	EL_SHARED_INSTALLER_MAIN_WINDOW

create
	make

feature {NONE} -- Initialization

	make
		do
			default_create
			enable_border
			disable_user_resize
			set_size (
				Screen.horizontal_pixels (A5_landscape.width * 1.3).min (Screen.useable_area.width),
				Screen.vertical_pixels (A5_landscape.height)
			)
			show_actions.extend (agent on_show)
			file_copy_box := Main.new_file_copy_box (Current)
			put (file_copy_box)
			set_default_cancel_button (file_copy_box.cancel_button)
		end

feature {EL_INSTALLER_BOX} -- Event handling

	on_next
		do
		end

	on_show
		do
			file_copy_box.install
		end

feature {NONE} -- Internal attributes

	file_copy_box: EL_FILE_COPY_INSTALLER_BOX

end