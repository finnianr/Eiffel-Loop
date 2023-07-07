note
	description: "Installer main window"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-07 12:17:01 GMT (Friday 7th July 2023)"
	revision: "11"

deferred class
	EL_INSTALLER_MAIN_WINDOW

inherit
	EL_TITLED_WINDOW
		redefine
			 prepare_to_show, make
		end

	EL_UI_COMPONENT_FACTORY
		undefine
			default_create, copy
		end

	EL_MODULE_DESKTOP_MENU_ICON

	EL_SHARED_PACKAGE_IMAGES_SCOPE

	EL_SHARED_INSTALL_TEXTS

	EL_SOLITARY
		rename
			make as make_solitary
		end

feature {NONE} -- Initialization

	make
		do
			make_solitary
			across Use_package_images as package loop
				Precursor
				set_icon_pixmap (Desktop_menu_icon.pixmap (png_logo_icon))
				updates_info := new_updates_info
			end
		end

feature -- Access

	png_logo_icon: FILE_PATH
		-- Icon relative to `Package_dir' directory
		deferred
		end

	png_title_background: FILE_PATH
		-- Icon relative to `Package_dir' directory
		deferred
		end

feature -- Factory

	new_file_copy_box (dialog: EL_INSTALLER_DIALOG): EL_FILE_COPY_INSTALLER_BOX
		do
			create Result.make (dialog)
		end

feature {NONE} -- Implementation

	prepare_to_show
		do
			Action.do_once_on_idle (agent on_show)
		end

feature {NONE} -- Event handler

	on_show
			--
		do
			minimize -- hide while still showing application in task switcher

			if updates_info.is_valid then
				show_install_dialog
			else
				show_error_dialog
			end
			close_application
		end

feature {NONE} -- Implementation

	cover_window (dialog: EV_DIALOG)
		do
			set_position (dialog.screen_x, dialog.screen_y)
		end

	new_updates_info: EL_SOFTWARE_UPDATE_INFO
		do
			create {EL_DEFAULT_SOFTWARE_UPDATE_INFO} Result.make
		end

	retry_update_info (dialog: EL_ERROR_DIALOG)
		do
			updates_info.build
			if updates_info.is_valid then
				dialog.destroy
				show_install_dialog
			end
		end

	show_error_dialog
		local
			dialog: EL_ERROR_DIALOG
		do
			create dialog.make_with_text (Text.unable_to_connect (domain_name, email))
			dialog.set_title (Text.web_connection_error)
			dialog.set_label_font (new_dialog_label_font)
			dialog.retry_button.select_actions.extend (agent retry_update_info (dialog))

			cover_window (dialog); Screen.center (dialog)
			dialog.show_modal_to_window (Current)
		end

	show_install_dialog
		local
			a5_dialog: EL_PAPER_SIZE_MATCHING_DIALOG; installer_dialog: EL_INSTALLER_DIALOG
		do
			create a5_dialog.make (updates_info.latest_version)
			cover_window (a5_dialog)
			Screen.center (a5_dialog)

			a5_dialog.show_modal_to_window (Current)
			if not a5_dialog.is_cancelled then
				create installer_dialog.make
				Screen.center (installer_dialog)
				installer_dialog.show_modal_to_window (Current)
			end
		end

feature {NONE} -- Deferred Implementation

	domain_name: ZSTRING
		deferred
		end

	email: ZSTRING
		deferred
		end

feature {NONE} -- Internal attributes

	updates_info: like new_updates_info
end