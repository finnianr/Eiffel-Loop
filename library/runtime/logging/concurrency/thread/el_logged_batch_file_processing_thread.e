note
	description: "Logged ${EL_BATCH_FILE_PROCESSING_THREAD}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "4"

deferred class
	EL_LOGGED_BATCH_FILE_PROCESSING_THREAD

inherit
	EL_BATCH_FILE_PROCESSING_THREAD
		redefine
			do_execution, on_start, call_process_file
		end

	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

feature {NONE} -- Event handling

	on_start
		do
			Log_manager.add_thread (Current)
			Log_manager.redirect_thread_to_console (2)
		end

feature {EL_INTERNAL_THREAD} -- Implementation

	call_process_file
		do
			log.enter_with_args ("process_file", arguments)
			precursor
			log.exit
		end

	do_execution
			--
		do
			log.enter ("execute")
			Precursor
			log.exit
		end
end