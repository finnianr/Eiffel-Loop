note
	description: "Summary description for {EL_LOGGED_CONSUMER_THREAD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-03 12:10:07 GMT (Sunday 3rd July 2016)"
	revision: "4"

deferred class
	EL_LOGGED_CONSUMER_THREAD [P]

inherit
	EL_CONSUMER_THREAD [P]
		redefine
			set_waiting, on_continue, on_start
		end

	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

feature {NONE} -- Event handling

	on_continue
			-- Continue after waiting
		do
			log.put_line ("received " + product.generator + " object")
		end

	on_start
		do
			Log_manager.add_thread (Current)
		end

	set_waiting
			-- Continuous loop to do action that waits to be prompted
		do
			log.put_line ("waiting")
			Precursor
		end

end
