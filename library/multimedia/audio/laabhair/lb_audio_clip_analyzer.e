note
	description: "Consumes audio clips for analysis and posts results as XML remote procedure call messages"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "2"

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

