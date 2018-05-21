note
	description: "Audio source producer thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:05 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_AUDIO_SOURCE_PRODUCER_THREAD

inherit
	EL_PROCEDURE_CALL_CONSUMER_THREAD [TUPLE]
		redefine
			on_start
		end

	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

feature {NONE} -- Implementation

	on_start
		do
			Log_manager.add_thread (Current)
		end
end
