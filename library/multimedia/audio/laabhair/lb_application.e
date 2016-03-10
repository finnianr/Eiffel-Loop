note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	LB_APPLICATION

inherit
	WEL_APPLICATION
		redefine
			init_application, run
		end
	
	EL_LOGGING_ROOT
	
feature {NONE} -- Implementation
	
	run
			--
		do
			log.enter ("run")
			Precursor
			log.exit
		end
	
	init_application
			-- May be defined to load DLLs.
		do
			create common_controls_dll.make
			
			set_logging_from_command_line_option ("logging")
			
			if is_global_logging_on then
				log.set_routines_to_log (log_filter)
			else
				io.put_string ("Thread logging disabled")
				io.put_new_line
			end				

			set_default_thread_log_file_name
			log.put_configuration_info (log_filter)
		end
	
	main_window: WEL_FRAME_WINDOW
			-- Create the application's main window
		deferred
		end
	
	common_controls_dll: WEL_COMMON_CONTROLS_DLL

	log_filter: ARRAY [ARRAY [STRING]]
			--
		deferred
		end
		
end





