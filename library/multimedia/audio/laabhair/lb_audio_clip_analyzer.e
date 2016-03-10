note
	description: "Consumes audio clips for analysis and posts results as XML remote procedure call messages"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

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

