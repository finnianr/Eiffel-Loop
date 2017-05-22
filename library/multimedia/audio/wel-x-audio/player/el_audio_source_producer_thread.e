note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "1"

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
