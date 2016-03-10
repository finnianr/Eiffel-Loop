note
	description: "Basic Laabhair user defined application configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
	LB_BASIC_APP_CONFIGURATION

inherit
	EL_APP_CONFIGURATION
		redefine
			make
		end
		
	LB_CONSTANTS
		
	EL_LOGGING

feature {NONE} -- Initialization

	make
			--
		do
			log.enter ("make")
			Precursor
			command_line_help.split ('%N').do_all (agent log.put_line)
			log.exit
		end

feature {NONE} -- Initialization

	read_command_line_args
			--
		do
			-- Debug options
			set_option (
				"logging", is_logging_enabled, "[
				Thread logging enabled: $VALUE
				   (Command option: -logging)
			]")
				-- NB Logging option is only set for the help info
				-- The actual logging is enabled by using: {ARGUMENTS}.index_of_word_option
				-- because this configuration class itself uses logging

			set_option (
				"fdebug", is_debug_flash_mode, "[
				Manual launch of SWF movie in Flash IDE: $VALUE
				   (Command option: -fdebug)
			]")

			-- Audio setup
			set_argument (
				"script", script_file_name, "[
				Praat script: "$VALUE"
				   (Change with: -script <script_file_name>)
			]")
			set_argument (
				"interval", sample_interval_millisecs, "[
				Sample interval: $VALUE millisecs
				   (Change with: -interval <milli_seconds> )
			]")
			set_argument (
				"signal", signal_threshold, "[
				Signal threshold (root mean square): $VALUE
				   (Change with: -signal <threshold_level>)
			]")
			
		end

	create_editable_fields
			--
		do
			create is_logging_enabled.make (Current, false)
			create is_debug_flash_mode.make (Current, Default_is_debug_flash_mode)
			
			create script_file_name.make (Current, Default_script_file_name)
			add_field (script_file_name)
			
			create sample_interval_millisecs.make (Current, Default_sample_interval_millisecs)
			add_field (sample_interval_millisecs)
			
			create signal_threshold.make (Current, Default_signal_threshold)
			add_field (signal_threshold)
			
		end

feature -- Access

	sample_interval_millisecs: EL_EDITABLE_INTEGER

	script_file_name: EL_EDITABLE_STRING

	is_debug_flash_mode: EL_EDITABLE_BOOLEAN

	is_logging_enabled: EL_EDITABLE_BOOLEAN

	signal_threshold: EL_EDITABLE_REAL
	
	Flash_receive_msg_port_num: INTEGER = 8000

	Flash_send_msg_port_num: INTEGER = 8001
	
feature {NONE} -- Implementation

	put_error_message (option: STRING; arg_value: STRING)
			--
		do
			log.put_string ("Invalid command line argument ")
			log.put_string (option)
			log.put_string (": ")
			log.put_string (arg_value)
			log.put_new_line
		end
	
feature -- Default values

	Default_sample_interval_millisecs: INTEGER

		deferred
		end

	Default_signal_threshold: REAL

		deferred
		end
	
end







