note
	description: "File copy installer box"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 16:31:20 GMT (Sunday 22nd September 2024)"
	revision: "24"

class
	EL_FILE_COPY_INSTALLER_BOX

inherit
	EL_INSTALLER_BOX
		rename
			make as make_installer_box,
			Word as Word_common
		redefine
			dialog
		end

	EL_PROGRESS_DISPLAY
		rename
			on_finish as on_finish_stage
		undefine
			default_create, copy, is_equal
		end

	EL_MODULE_FILE_SYSTEM; EL_MODULE_FILE; EL_MODULE_LIO; EL_MODULE_IMAGE; EL_MODULE_TRACK

	EL_APPLICATION_CONSTANTS; EL_STRING_8_CONSTANTS

	EL_SHARED_APPLICATION_OPTION; EL_SHARED_APPLICATION_LIST

	EL_SHARED_INSTALL_TEXTS; EL_SHARED_INSTALLER_MAIN_WINDOW

	EL_SHARED_PACKAGE_IMAGES_SCOPE; EL_SHARED_EV_APPLICATION

create
	make

feature {NONE} -- Initialization

	make (a_dialog: like dialog)
		do
			make_installer_box (a_dialog, 0, 0)
			cancel_button.set_text (Text.finish)
			cancel_button.disable_sensitive
			create progress_bar
			progress_bar.disable_segmentation

			file_path_label := Vision_2.new_label_with_font (Empty_string_8, new_font (Size.small))
			action_label := Vision_2.new_label_with_font ("", new_font (Size.small))

			set_label (action_label, Text.contacting_server)

			extend_unexpanded (new_title_frame)
			extend (new_components_box)
		end

feature -- Basic operations

	copy_files
		-- This is now done with Debian install on Unix
		require
			not_unix: not {PLATFORM}.is_unix
		local
			file_list: like File_system.files; l_file: EL_NOTIFYING_RAW_FILE
			relative_path, destination_path: FILE_PATH;
		do
			file_list := File_system.files (Package_dir, True)
			across file_list as file_path loop
				Track.increase_file_data_estimate (file_path.item) -- Read bytes
				Track.increase_file_data_estimate (file_path.item) -- Write bytes
			end
			across file_list as file_path loop
				create l_file.make_with_name (file_path.item)
				relative_path := file_path.item.relative_path (Package_dir)
				set_label (file_path_label, relative_path)
				destination_path := Directory.Application_installation + relative_path
--				lio.put_path_field ("Copying", file_path.item)
--				lio.put_new_line
--				lio.put_path_field ("%Tto", destination_path)
--				lio.put_new_line
				File.copy_contents (l_file, destination_path)
				if destination_path.parent.base ~ Bin_dir then
					File.add_permission (destination_path, "uog", "x")
				end
			end
		end

	install
		do
			ev_application.process_events -- Ensure dialog becomes visible on GTK

			across new_stage_actions as list loop
				is_final_stage := list.is_last
				current_stage := list.key
				Track.data_transfer (Current, 0, list.item)
			end
		end

feature {NONE} -- Factory

	new_button_box: EL_HORIZONTAL_BOX
		do
			create Result.make_unexpanded (0, 0.3, << create {EL_EXPANDED_CELL}, cancel_button >>)
		end

	new_title_frame: EL_LABEL_PIXMAP
		do
			create Result.make_with_text_and_font (Text.install_title, new_font (Size.medium))
			Result.align_text_center
			across Use_package_images as package loop
				Result.set_tile_pixmap (Image.of_height_cms (Main.png_title_background, 1.5))
			end
		end

feature {NONE} -- Event handling

	on_finish_stage
		do
			if is_final_stage then
				install_menus
				cancel_button.enable_sensitive
				cancel_button.set_focus
			else
				file_path_label.remove_text
			end
			ev_application.process_events
		end

	on_start (tick_byte_count: INTEGER)
		do
		end

	set_identified_text (id: INTEGER; a_text: READABLE_STRING_GENERAL)
		-- called from {EL_RESOURCE_INSTALL_MANAGER}.download
		do
			if id = 0 then
				set_label (action_label, a_text)
			end
		end

	set_progress (proportion: DOUBLE)
		do
			progress_bar.set_proportion (proportion.truncated_to_real)
			ev_application.process_events
		end

feature {NONE} -- Implementation

	install_menus
		do
			if not (App_option.test or {PLATFORM}.is_unix) then
				lio.put_line ("Installing menus")
				Application_list.install_menus
			end
			action_label.set_text (Text.installation_complete)
		end

	set_label (a_label: EL_LABEL; a_text: READABLE_STRING_GENERAL)
		do
			if a_label = action_label then
				a_label.set_text (a_text + " ..")
			else
				a_label.set_text (a_text)
			end
		end

	new_components_box: EL_VERTICAL_BOX
		do
			create Result.make_unexpanded (0.5, 0.3, <<
				action_label, progress_bar, file_path_label, new_button_box
			>>)
		end

	new_stage_actions: EL_HASH_TABLE [PROCEDURE, INTEGER]
		do
			create Result.make (5)

			-- This is now done with Debian install
			Result [Stage_copy_files] := if {PLATFORM}.is_unix then agent do_nothing else agent copy_files end
		end

feature {NONE} -- Internal attributes

	action_label: EL_LABEL

	dialog: EL_INSTALLER_DIALOG

	current_stage: INTEGER

	file_path_label: EL_LABEL

	progress_bar: EV_HORIZONTAL_PROGRESS_BAR

	is_final_stage: BOOLEAN

feature {NONE} -- Constants

	Bin_dir: ZSTRING
		once
			Result := "bin"
		end

	Ellipsis: ZSTRING
		once
			Result := " .."
		end

	Stage_copy_files: INTEGER = 1

end