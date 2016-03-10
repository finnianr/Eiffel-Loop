note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	LB_MAIN_WINDOW [
		AUDIO_CLIP_ANALYSER_TYPE -> LB_AUDIO_CLIP_ANALYZER create make end,
		LB_MICROPHONE_FLASH_UI_TYPE -> LB_MICROPHONE_FLASH_UI_LISTENER  create make end,
		CONFIGURATION_EDIT_WINDOW_TYPE -> LB_BASIC_CONFIG_EDIT_DIALOG create make_child end
	]

inherit
	EL_WEL_FRAME_WINDOW
		undefine
			class_icon
		redefine
			default_process_message, destroy,
			on_size, on_wm_close, on_wm_nc_destroy, on_menu_command, Background_brush,
			default_width, default_height, closeable, default_style
		end

	EL_AUDIO_INPUT_CONTROLLER
		rename
			default_process_message as process_audio_input_message,
			make as make_audio_input,
			hwindow as item,
			audio_clip_consumer as audio_clip_saver
		export
			{NONE} all
		redefine
			start_recording, stop_recording
		end

	LB_AUDIO_INPUT_WINDOW
	
	LB_SHARED_CONFIGURATION
		
	LB_WEL_WINDOW_IDS
	
	WEL_SIZE_CONSTANTS

	EL_SHARED_THREAD_MANAGER
	
feature {NONE} -- Initialization

	make
			-- Create the main dialog and the commands.
		do
			log.enter ("make")
			make_top (Window_title)
			make_audio_input (Audio_format, config.Sample_interval_millisecs.item)
			make_gui_components
			make_speech_analysis_components
			
			create recording_timer.make
			create flash_application.make (audio_analyser.flash_rpc_request_queue)
			
			Config.register_change_action (
				<< Config.sample_interval_millisecs >>, agent set_sample_interval_millisecs
			)
			Config.register_change_action (
				<< Config.signal_threshold >>, agent set_signal_threshold
			)
			log.exit
		end

	make_gui_components
			--
		local
			audio_monitor_x_pos: INTEGER
		do
			move (screen_width - width, 0)
			
			set_menu (main_menu)

			create configuration_edit_window.make_child (Current, window_title + " configuration")
			
			if is_global_logging_on then
				create console_manager_dialog.make_child (Current, window_title + " Console Thread Selector")
			else
				main_menu.disable_item (Cmd_console_controller)
			end

			create flash_gui_event_listener.make (
				create {LB_AUDIO_INPUT_WINDOW_THREAD_PROXY}.make (Current)
			)
			flash_gui_event_listener.launch
			
			create status_light.make (
				Current, (Audio_monitor_size.height * 0.6).rounded , 8, (Audio_monitor_size.height * 0.3).rounded
			)

			audio_monitor_x_pos := status_light.x + status_light.width + 10
			create audio_monitor.make (
				Current, "Audio level",
				audio_monitor_x_pos , 0,
				Audio_monitor_size.width, Audio_monitor_size.height
			)
			audio_monitor.set_signal_threshold (Config.signal_threshold.item)
			
			stay_on_top
		end

	make_speech_analysis_components
			--
		do
			audio_clip_saver.set_sound_level_listener (audio_monitor.signal_level_meter)
			-- Start consuming
			audio_clip_saver.launch
			thread_manager.register (audio_clip_saver)
			
			create flash_remote_procedure_invoker.make (config.Flash_send_msg_port_num)
			flash_remote_procedure_invoker.launch
			thread_manager.register (flash_remote_procedure_invoker)
			
			create audio_analyser.make (flash_remote_procedure_invoker)

			audio_clip_saver.audio_file_processing_queue.attach_consumer (audio_analyser)	

			-- Start consuming
			audio_analyser.launch 				
			thread_manager.register (audio_analyser)
				
		end

feature -- Event handlers

	on_menu_command (menu_id: INTEGER)
			--
		local
			msg_box: WEL_MSG_BOX
		do
			inspect menu_id
				when Cmd_command_line_help then
					create msg_box.make
					msg_box.information_message_box (
						Current, Config.command_line_help, Window_title + " Command Line Help"
					)
					
				when Cmd_credits then
					create msg_box.make
					msg_box.information_message_box (
						Current, Credits, "About " + Window_title
					)

				when Cmd_edit_config then
					configuration_edit_window.show
					configuration_edit_window.set_focus
					
				when Cmd_console_controller then
					console_manager_dialog.show
					console_manager_dialog.set_focus
					
			end	
		end

	on_size (size_type: INTEGER; a_width: INTEGER; a_height: INTEGER)
			-- Reposition the status window and the tool bar when
			-- the window has been resized.
		do
			if flash_application /= Void then
				inspect size_type
					when Size_minimized then
						flash_application.full_screen (false)
					
					when Size_restored then
						move (screen_width - width, 0)
--						if not flash_application.is_full_screen then
							flash_application.full_screen (true)
--						end
	
					else
				end
			end
		end

	on_wm_close
			--
		do
			log.enter ("on_wm_close")
			Precursor
			flash_application.quit
			
			log.exit
		end
		
	on_wm_nc_destroy
			-- Quit the application
		do
			log.enter ("on_wm_nc_destroy")
			Precursor

			thread_manager.stop_all
			flash_gui_event_listener.ok_to_close_connection.signal
			join_all
			
			log.put_line ("FINISHED!")
			log.exit
		end

feature {NONE} -- Element change

	set_sample_interval_millisecs
			-- Update configuration from edit configuration dialog
		do
			log.enter ("set_sample_interval_millisecs")
			set_clip_duration_millisecs (Config.sample_interval_millisecs.item)
			log.exit
		end

	set_signal_threshold
			--
		do
			log.enter ("set_signal_threshold")
			audio_clip_saver.set_signal_threshold (Config.signal_threshold.item)
			audio_monitor.set_signal_threshold (Config.signal_threshold.item)
			log.exit
		end

feature {NONE} -- Implementation

	destroy
			-- 
		do
			if is_recording then
				stop_recording
			end
			Precursor
		end
		
	start_recording
			-- User pressed start button
		do
			log.enter ("start_recording")
			-- Apply any configuration editions
			Config.notify_changes
			
			recording_timer.start

			audio_clip_saver.reset_sample_count
			status_light.set_status_on
			
			menu.disable_item (Cmd_edit_config)
			
			Precursor
			log.exit			
		end

	stop_recording
			-- User pressed stop button
		local
			expected_samples_count: INTEGER
		do
			log.enter ("stop_recording")
			Precursor
			recording_timer.stop

			log.put_string ("Recording time: ")
			log.put_double (recording_timer.elapsed_time.fine_seconds_count)
			log.put_line (" secs")
			
			expected_samples_count :=
				(Audio_format.samples_per_sec * recording_timer.elapsed_time.fine_seconds_count).rounded
				
			log.put_integer_field ("Expected number of samples", expected_samples_count)
			log.put_new_line

			log.put_integer_field("Actual number of samples", audio_clip_saver.samples_recorded_count)
			log.put_new_line

			status_light.set_status_off

			menu.enable_item (Cmd_edit_config)
			log.exit
		end
		

	default_process_message (msg: INTEGER; wparam, lparam: POINTER)
			-- Process `msg' which has not been processed by
		do
			Precursor (msg, wparam, lparam)
			process_audio_input_message (msg, wparam, lparam)
		end

	audio_monitor: EL_AUDIO_MONITOR

	status_light: EL_STATUS_INDICATOR_LIGHT
	
	audio_clip_saver: EL_AUDIO_CLIP_SAVER
			-- Audio clips are first saved to disk before processing by Praat
		once
			create Result.make (Config.signal_threshold.item)
		end
	
	flash_remote_procedure_invoker: EL_FLASH_XML_NETWORK_MESSENGER
	
	flash_gui_event_listener: LB_MICROPHONE_FLASH_UI_TYPE

	flash_application: LB_FLASH_APPLICATION_PROXY

	audio_analyser: AUDIO_CLIP_ANALYSER_TYPE

	configuration_edit_window: CONFIGURATION_EDIT_WINDOW_TYPE

	console_manager_dialog:	LB_CONSOLE_MANAGER_DIALOG
	
	recording_timer: EL_TIMER

	closeable: BOOLEAN = false
			-- Can the user close the window?
			-- Yes she can, but not before Flash knows about it.

	stay_on_top
			-- Cause window to be always on top
		local
			rect: WEL_RECT
		do
			rect := window_rect
			cwin_set_window_pos (item, Hwnd_topmost, rect.x, rect.y, rect.width, rect.height, Swp_showWindow )
		end
	
feature {NONE} -- Default creation values

	Window_title: STRING
			--
		deferred
		end

	Credits: STRING
			--
		deferred
		end

	Background_brush: WEL_BRUSH
			-- background color
		do
			create Result.make_by_sys_color (Color_btnface + 1)
		end

	Main_menu: WEL_MENU
			-- Window's menu
		once
			create Result.make_by_id (ID_main_menu)
		ensure
			result_not_void: Result /= Void
		end
	
	Audio_format: EL_16BIT_MONO_PCM_WAVE_FORMAT
			--
		once
			create Result.make (22050)
		end

	Caption_and_menu_height: INTEGER
			--
		once
			Result := minimal_height * 2
		end

	Default_style: INTEGER
			-- Overlapped window style.
			-- By default, a frame window is not visible
			-- at the creation time. `show' needs to be called.
			-- This solution avoids a bad visual effect when
			-- the children are created one by one inside
			-- the window.
		once
			Result := WS_caption | WS_sysmenu | Ws_minimizebox
		end

		
	Default_width: INTEGER
			--
		once
			Result := (Audio_monitor_size.width * 1.2).rounded
		end
		
	Default_height: INTEGER
			--
		once
			Result := Client_height + Caption_and_menu_height
		end

	Client_height: INTEGER
			--
		once
			Result := (Audio_monitor_size.height * 1.1).rounded
		end
	
	Audio_monitor_size: WEL_SIZE
			--
		once
			create Result.make (330, 50)
		end
		
end











