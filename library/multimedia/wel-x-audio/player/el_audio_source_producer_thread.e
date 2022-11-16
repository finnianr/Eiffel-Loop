note
	description: "Audio source producer thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_AUDIO_SOURCE_PRODUCER_THREAD

inherit
	EL_PROCEDURE_CALL_CONSUMER_THREAD
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