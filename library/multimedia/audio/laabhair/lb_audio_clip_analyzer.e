note
	description: "Consumes audio clips for analysis and posts results as XML remote procedure call messages"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
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
