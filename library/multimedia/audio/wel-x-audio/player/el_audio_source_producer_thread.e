note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

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
