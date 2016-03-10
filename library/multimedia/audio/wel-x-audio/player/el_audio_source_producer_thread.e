note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_AUDIO_SOURCE_PRODUCER_THREAD [SAMPLE_TYPE -> EL_AUDIO_PCM_SAMPLE create make end]

inherit
	EL_PROCEDURE_CALL_CONSUMER_THREAD [EL_AUDIO_SOURCE_PRODUCER [SAMPLE_TYPE], TUPLE]
		redefine
			Is_visible_in_console
		end

feature -- Constants

	Is_visible_in_console: BOOLEAN = true

end
