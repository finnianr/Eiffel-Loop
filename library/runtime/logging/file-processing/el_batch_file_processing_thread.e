note
	description: "Batch file processing thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-24 14:12:30 GMT (Tuesday 24th December 2019)"
	revision: "5"

deferred class
	EL_BATCH_FILE_PROCESSING_THREAD

inherit
	EL_TUPLE_CONSUMER_THREAD [TUPLE [EL_FILE_PATH, EL_DIR_PATH, STRING, STRING]]
		rename
			make as make_consumer
		redefine
			do_execution, on_start
		end

	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

feature {NONE} -- Initialization

	make (event_listener: EL_EVENT_LISTENER)
			--
		do
			make_consumer
			file_processed_event_listener := event_listener
			set_action (agent process_file_and_notify_listener)
		end

feature {NONE} -- Basic operations

	process_file (
		input_file_path: EL_FILE_PATH; output_directory: EL_DIR_PATH
		input_file_name, input_file_extension: STRING
	)
			--
		deferred
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

feature {NONE} -- Event handling

	on_start
		do
			Log_manager.add_thread (Current)
			log_manager.redirect_thread_to_console (2)
		end

feature {EL_INTERNAL_THREAD} -- Implementation

	do_execution
			--
		do
			log.enter ("execute")
			Precursor
			log.exit
		end

feature {NONE} -- Internal attributes

	file_processed_event_listener: EL_EVENT_LISTENER

end
