note
	description: "Batch file processing thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "9"

deferred class
	EL_BATCH_FILE_PROCESSING_THREAD

inherit
	EL_ACTION_ARGUMENTS_CONSUMER_THREAD [FILE_PATH, DIR_PATH, STRING, STRING]
		rename
			call_actions as call_process_file,
			make as make_thread
		redefine
			make_thread
		end

feature {NONE} -- Initialization

	make (a_event_listener: EL_EVENT_LISTENER)
		do
			make_thread
			event_listener := a_event_listener
			extend (agent process_file_and_notify_listener)
		end

	make_thread
		do
			Precursor
			create {EL_DEFAULT_EVENT_LISTENER} event_listener
		end

feature {NONE} -- Basic operations

	process_file (
		input_file_path: FILE_PATH; output_directory: DIR_PATH
		input_file_name, input_file_extension: STRING
	)
		deferred
		end

	process_file_and_notify_listener (
		input_file_path: FILE_PATH; output_directory: DIR_PATH
		input_file_name, input_file_extension: STRING
	)
		do
			process_file (input_file_path, output_directory, input_file_name, input_file_extension)
			event_listener.notify
		end

feature {NONE} -- Internal attributes

	event_listener: EL_EVENT_LISTENER
		-- file processed event listener

end