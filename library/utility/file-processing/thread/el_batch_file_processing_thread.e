note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:21 GMT (Tuesday 18th June 2013)"
	revision: "2"

deferred class
	EL_BATCH_FILE_PROCESSING_THREAD

inherit
	EL_TUPLE_CONSUMER_THREAD [EL_BATCH_FILE_PROCESSING_THREAD, TUPLE [EL_FILE_PATH, EL_DIR_PATH, STRING, STRING]]
		rename
			make as make_consumer
		redefine
			execute
		end

	EL_MODULE_LOG
		undefine
			default_create, is_equal, copy
		end

feature {NONE} -- Initialization

	make (event_listener: EL_EVENT_LISTENER)
			--
		do
			make_consumer
			file_processed_event_listener := event_listener
			set_action (agent process_file_and_notify_listener)
		end

feature {NONE} -- Basic operations

	execute
			--
		do
			log_manager.redirect_thread_to_console (2)
			log.enter ("execute")
			Precursor
			log.exit
		end

	process_file_and_notify_listener (
		input_file_path: EL_FILE_PATH; output_directory: EL_DIR_PATH
		input_file_name, input_file_extension: STRING
	)
			--
		do
			process_file (input_file_path, output_directory, input_file_name, input_file_extension)
			file_processed_event_listener.notify
		end

	process_file (
		input_file_path: EL_FILE_PATH; output_directory: EL_DIR_PATH
		input_file_name, input_file_extension: STRING
	)
			--
		deferred
		end

feature {NONE} -- Implementation

	file_processed_event_listener: EL_EVENT_LISTENER

end
