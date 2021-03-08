note
	description: "Batch file processing thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-06 12:25:02 GMT (Saturday 6th March 2021)"
	revision: "6"

deferred class
	EL_BATCH_FILE_PROCESSING_THREAD

inherit
	EL_ACTION_ARGUMENTS_CONSUMER_THREAD [EL_FILE_PATH, EL_DIR_PATH, STRING, STRING]
		rename
			call_actions as call_process_file,
			make as make_thread
		end

feature {NONE} -- Initialization

	make (event_listener: EL_EVENT_LISTENER)
		do
			make_thread
			file_processed_event_listener := event_listener
			extend (agent process_file_and_notify_listener)
		end

feature {NONE} -- Basic operations

	process_file (
		input_file_path: EL_FILE_PATH; output_directory: EL_DIR_PATH
		input_file_name, input_file_extension: STRING
	)
		deferred
		end

	process_file_and_notify_listener (
		input_file_path: EL_FILE_PATH; output_directory: EL_DIR_PATH
		input_file_name, input_file_extension: STRING
	)
		do
			process_file (input_file_path, output_directory, input_file_name, input_file_extension)
			file_processed_event_listener.notify
		end

feature {NONE} -- Internal attributes

	file_processed_event_listener: EL_EVENT_LISTENER

end