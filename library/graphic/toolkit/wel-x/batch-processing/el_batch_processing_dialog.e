note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "4"

deferred class
	EL_BATCH_PROCESSING_DIALOG [G]

inherit
	EL_WEL_MAIN_DIALOG
		redefine
			on_menu_command, on_control_id_command, on_paint,
			notify, activate, terminate
		end

	EL_EVENT_LISTENER
		rename
			notify as on_file_processed
		end

	WEL_EN_CONSTANTS
		export
			{NONE} all
		end

	WEL_IDC_CONSTANTS
		export
			{NONE} all
		end

	WEL_UNIT_CONVERSION
		export
			{NONE} all
		end

	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

	EL_MODULE_DIRECTORY

	EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

	EL_SHARED_THREAD_MANAGER
		export
			{NONE} all
		undefine
			copy, default_create
		end

feature {NONE} -- Initialization

	make
			-- Make the main window

		do
			make_by_id (Id_main_dialog)
			create output_dir_edit.make_by_id (Current, id_edit_output_directory)
			create input_dir_edit.make_by_id (Current, id_edit_input_directory)
			create process_files_button.make_by_id (Current, Cmd_process_files)
			create cancel_button.make_by_id (Current, Cmd_cancel)

			system_color_window_cell.put (white_brush.color)

			create timer.make
			create directory_content_processor.make

			create file_processed_event_proxy.make (Current)
			make_processing_thread

			create request_processing_queue.make
			request_processing_queue.attach_consumer (processing_thread)
			thread_manager.extend (processing_thread)
		end

	make_processing_thread
			--
		deferred
		end

feature {NONE} -- Behaviours

	on_directory_select_input
		do
			open_input_dir_dialog.activate (Current)
			if open_input_dir_dialog.selected then
				input_dir_edit.set_text (open_input_dir_dialog.folder_name)
			end
		end

	on_directory_select_output
		do
			open_ouput_dir_dialog.activate (Current)
			if open_ouput_dir_dialog.selected then
				output_dir_edit.set_text (open_ouput_dir_dialog.folder_name)
			end
		end

	on_control_id_command (an_id: INTEGER)
			--
		do

			if an_id = Cmd_directory_browse_output then
				on_directory_select_output

			elseif an_id = Cmd_directory_browse_input then
				on_directory_select_input

			elseif an_id = Cmd_process_files then
				on_process_files

			elseif an_id = Cmd_cancel then
				on_cancel_processing

			end
		end

	on_menu_command (id_menu: INTEGER)
			--
		local
			about: WEL_MODAL_DIALOG
		do

			if id_menu = Cmd_exit then
					terminate (Idok)

			elseif id_menu = Cmd_help_about then
				create about.make_by_id (Current, Id_about_dialog)
				about.activate

			end
		end

	on_paint (paint_dc: WEL_PAINT_DC; invalid_rect: WEL_RECT)
			-- Draw the ISE logo bitmap
		do
			paint_dc.draw_bitmap (
				logo,
				cancel_button.x + cancel_button.width + 20,
				cancel_button.y - 10,
				logo.width, logo.height
			)
		end

	on_process_files
			--
		do
			log.enter ("on_process_files")
			if file_exists (input_dir_edit.text)
				and then not is_processing
			then

				create pointer_cursor.make_by_predefined_id (Idc_wait)
				pointer_cursor.set
				set_processing_thread_parameters

				files_to_process := 0
				files_processed := 0
				directory_content_processor.set_input_dir (Directory.directory_name (input_dir_edit.text))
				directory_content_processor.set_output_dir (Directory.directory_name (output_dir_edit.text))

				timer.start
				directory_content_processor.do_all (agent queue_file_for_processing, "*.wav")
				cancel_button.enable
				is_processing := true
				is_cancelled := false
				on_file_processed
			end
			log.exit
		end

	on_file_processed
			--
		local
			button_text: STRING
		do
			log.enter ("on_file_processed")
			files_processed := files_processed + 1

			log.put_string ("Processing ")
			log.put_integer (files_processed)
			log.put_string (" of ")
			log.put_integer (files_to_process)
			log.put_new_line

			if files_processed > files_to_process then
				on_process_complete
			else
				create button_text.make_from_string ("Processing ")
				button_text.append_integer (files_processed)
				button_text.append (" of ")
				button_text.append_integer (files_to_process)
				process_files_button.set_text (button_text)
			end
			log.exit
		end

	on_process_complete
			--
		local
			msg_box: WEL_MSG_BOX
			msg_title: STRING
		do
			process_files_button.set_text (process_files_button_text)
			cancel_button.disable
			pointer_cursor.restore_previous
			is_processing := false
			timer.stop
			create msg_box.make
			if is_cancelled then
				msg_title := "BATCH CANCELLED"
			else
				msg_title := "BATCH COMPLETED"
			end
			msg_box.information_message_box (
				Current, "Processing time: " + timer.elapsed_mins_and_secs_string, msg_title
			)

		end

	on_cancel_processing
			--
		do
			files_processed := files_to_process
			process_files_button.set_text ("Cancelling..")
			cancel_button.disable
			is_cancelled := true
			request_processing_queue.wipe_out
		end

	notify (a_control: WEL_CONTROL; notify_code: INTEGER)
			--
		do
			if notify_code = En_change then
				if not input_dir_edit.text.is_empty
					and then file_exists (input_dir_edit.text)
					and then not output_dir_edit.text.is_empty
				then
					process_files_button.enable
				else
					process_files_button.disable
				end
			end
		end

	activate
			-- Activate the dialog.
		do
			Precursor
			set_class_icon (create {WEL_ICON}.make_by_id (ID_ICO_APPLICATION))
			process_files_button_text := process_files_button.text
			processing_thread.launch
			move (10, 10)
		end

	terminate (a_result: INTEGER)
			--
		do
			log_manager.redirect_thread_to_console (1)
			log.enter ("terminate")
			if is_processing then
				on_cancel_processing
			end
			thread_manager.stop_all
			log.put_line ("FINISHED!")
			log.exit
			Precursor (a_result)
		end

feature {NONE} -- GUI components

	output_dir_edit: WEL_SINGLE_LINE_EDIT

	input_dir_edit: WEL_SINGLE_LINE_EDIT

	process_files_button: WEL_PUSH_BUTTON

	cancel_button: WEL_PUSH_BUTTON

	open_input_dir_dialog: WEL_CHOOSE_FOLDER_DIALOG
		once
			create Result.make
			Result.set_title ("Select the input directory")
			Result.set_starting_folder (current_working_directory)
		ensure
			result_not_void: Result /= Void
		end

	open_ouput_dir_dialog: WEL_CHOOSE_FOLDER_DIALOG
		once
			create Result.make
			Result.set_title ("Select the ouput directory")
			Result.set_starting_folder (current_working_directory)
		ensure
			result_not_void: Result /= Void
		end

	file_menu: WEL_MENU
		once
			Result := menu.popup_menu (0)
		ensure
			result_not_void: Result /= Void
		end

	pointer_cursor: WEL_CURSOR

feature {NONE} -- Resource IDs

	Id_main_dialog: INTEGER
			--
		deferred
		end

	Id_menu_application: INTEGER
			--
		deferred
		end

	Id_ico_application: INTEGER
			--
		deferred
		end


	Id_bmp_logo: INTEGER
			--
		deferred
		end

	Id_about_dialog: INTEGER
			--
		deferred
		end

	Id_edit_input_directory: INTEGER
			--
		deferred
		end

	Id_edit_output_directory: INTEGER
			--
		deferred
		end

	Cmd_directory_browse_input: INTEGER
			--
		deferred
		end

	Cmd_directory_browse_output: INTEGER
			--
		deferred
		end

	Cmd_process_files: INTEGER
			--
		deferred
		end

	Cmd_cancel: INTEGER
			--
		deferred
		end

	Cmd_exit: INTEGER
			--
		deferred
		end

	Cmd_help_about: INTEGER
			--
		deferred
		end

feature {NONE} -- Implementation

	queue_file_for_processing (
		input_file_path: EL_FILE_PATH; output_dir: EL_DIR_PATH
		input_file_name, input_file_extension: STRING
	)
			--
		do
			request_processing_queue.put (
				process_request_item (input_file_path, output_dir, input_file_name, input_file_extension)
			)
			files_to_process := files_to_process + 1
		end

	process_request_item (
		input_file_path: EL_FILE_PATH; output_dir: EL_DIR_PATH
		input_file_name, input_file_extension: STRING
	): G
			--
		deferred
		end

	file_exists (filename: STRING): BOOLEAN
			-- Does `filename' exist?
		require
			filename_not_void: filename /= Void
		local
			a_file: PLAIN_TEXT_FILE
		do
			create a_file.make (filename)
			Result := a_file.exists
		end

	set_processing_thread_parameters
			--
		do
		end

	request_processing_queue: EL_THREAD_PRODUCT_QUEUE [G]

	directory_content_processor: EL_DIRECTORY_CONTENT_PROCESSOR

	process_files_button_text: STRING

	files_processed: INTEGER

	files_to_process: INTEGER

	is_processing: BOOLEAN

	is_cancelled: BOOLEAN

	timer: EL_EXECUTION_TIMER

	file_processed_event_proxy: EL_EVENT_LISTENER_MAIN_THREAD_PROXY
		-- Triggers notifications in main GUI thread

	processing_thread: EL_CONSUMER_THREAD [G]

feature {NONE} -- Constants

	Logo: WEL_BITMAP
			-- ISE logo bitmap
		once
			create Result.make_by_id (Id_bmp_logo)
		end

	White_brush: WEL_WHITE_BRUSH
			-- White background
		once
			create Result.make
		end

end
