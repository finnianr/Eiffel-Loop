note
	description: "Consumes audio clips for analysis and posts results as XML remote procedure call messages"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
	LB_AUDIO_CLIP_ANALYZER

inherit
	EL_PRAAT_AUDIO_CLIP_ANALYZER [STRING]
		rename
			result_queue as flash_RPC_request_queue
		export
			{LB_MAIN_WINDOW} flash_RPC_request_queue
		end

end

