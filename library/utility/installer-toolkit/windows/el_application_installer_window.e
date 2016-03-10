note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_APPLICATION_INSTALLER_WINDOW [INSTALLER_TYPE -> EL_APPLICATION_INSTALLER create make end]

inherit
	EL_TITLED_WINDOW_WITH_CONSOLE_MANAGER
		redefine
			 initialize
		end

	EV_FRAME_CONSTANTS
		undefine
			copy, default_create
		end

	EV_FONT_CONSTANTS
		undefine
			copy, default_create
		end

	EL_FILE_ROUTINES
		undefine
			copy , default_create
		end

	EXECUTION_ENVIRONMENT
		rename
			put as put_env_label
		export
			{NONE} all
		undefine
			copy , default_create
		end

	EL_LOGGING
		undefine
			copy , default_create
		end

create
	default_create

feature {NONE} -- Initialization

	initialize
   			-- Mark `Current' as initialized.
   			-- This must be called during the creation procedure
   			-- to satisfy the `is_initialized' invariant.
   			-- Descendants may redefine initialize to perform
   			-- additional setup tasks.
		do
			Precursor
			add_console_manager_toolbar
			set_close_request_actions

			create installer.make

			set_title (installer.Window_title)
			set_icon_pixmap (installer.Window_icon)

			add_components
		end

feature {NONE} -- Create UI

	add_components
			--
		local
			v_box: EV_VERTICAL_BOX
			h_box: EV_HORIZONTAL_BOX
		do
			create v_box
			v_box.set_border_width (10)
			v_box.set_padding_width (6)
			create h_box

			create install_dir_selector.make (installer.Default_application_home, Current)
			v_box.extend (label ("Select install location"))
			v_box.extend (install_dir_selector)

			create menu_shortcut_dir_selector.make (
				file_path (program_menu_directory_path, installer.Default_menu_folder_name), Current
			)
			v_box.extend (label ("Select menu shortcut location"))
			v_box.extend (menu_shortcut_dir_selector)

			v_box.extend (create {EV_FIXED})
			v_box.last.set_minimum_height (10)

			create desk_top_shortcut_check_box.make_with_text ("Create shortcut on desktop")
			desk_top_shortcut_check_box.set_font (Label_font)
			desk_top_shortcut_check_box.toggle
			v_box.extend (desk_top_shortcut_check_box)

			create h_box
			h_box.extend (logo)
			h_box.set_border_width (20)

			h_box.extend (create_install_box)
			v_box.extend (h_box)

			extend (v_box)
		end

	create_install_box: EV_VERTICAL_BOX
			--
		do
			create Result
			create install_button.make_with_text ("Install")
			install_button.select_actions.force_extend (agent on_install_button_clicked)
			install_button.set_font (Label_font)
			create status_label
			Result.extend (status_label)
			Result.extend (install_button)
			Result.disable_item_expand (install_button)
		end


feature {NONE} -- Handlers

	on_install_button_clicked
			--
		do
			log.enter ("on_install_button_clicked")
			if install_button.text.is_equal ("Finish") then
				close_request_actions.call ([])
			else
				set_pointer_style (Default_pixmaps.Busy_cursor)
				install_button.set_text ("Installing..")
				installer.set_application_home (install_dir_selector.directory_path)
				installer.set_program_menu_path (menu_shortcut_dir_selector.directory_path)
				installer.set_desktop_shortcut (desk_top_shortcut_check_box.is_selected)
				installer.install
				install_button.set_text ("Finish")
				status_label.set_font (Label_font)
				status_label.set_text ("Installation%Ncomplete")
				set_pointer_style (Default_pixmaps.Standard_cursor)
			end
			log.exit
		end

feature {NONE} -- Implementation

	label (text: STRING): EV_LABEL
			--
		do
			create Result.make_with_text (text)
			Result.set_font (Label_font)
			Result.align_text_left
		end

	logo: EV_FIXED
			--
		local
			logo_pixmap: EV_PIXMAP
		do
			logo_pixmap := installer.Application_logo_pixmap
			create logo_drawing_area
			logo_drawing_area.expose_actions.force_extend (agent redraw_logo)
			create Result
			Result.extend (logo_drawing_area)
			Result.set_item_size (logo_drawing_area, logo_pixmap.width,  logo_pixmap.height)

		end

	redraw_logo
			--
		do
			logo_drawing_area.clear
			logo_drawing_area.draw_pixmap (0, 0, installer.Application_logo_pixmap)
		end

	program_menu_directory_path: EL_DIR_PATH
			--
		local
			l_path_steps: LIST [STRING]
		once
			create Result.make_from_string (get ("USERPROFILE"))
			l_path_steps := path_steps (Result)
			l_path_steps.finish
			l_path_steps.remove
			Result := directory_path_from_steps (l_path_steps)
			Result.extend_from_array (<< "All Users", "Start Menu",  "Programs" >>)
		end

	installer: INSTALLER_TYPE

	status_label: EV_LABEL

	desk_top_shortcut_check_box: EV_CHECK_BUTTON

	install_dir_selector: EL_DIRECTORY_USER_SELECT

	menu_shortcut_dir_selector: EL_DIRECTORY_USER_SELECT

	install_button: EV_BUTTON

	logo_drawing_area: EV_DRAWING_AREA

feature {NONE} -- Constants

	Label_font: EV_FONT
			--
		do
			create Result.make_with_values (Family_sans, Weight_bold, Shape_regular, 16)
		end

	Stock_colors: EV_STOCK_COLORS
			--
		once
			create Result
		end

end
