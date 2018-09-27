note
	description: "Audio sample arrayed list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

deferred class
	EL_AUDIO_SAMPLE_ARRAYED_LIST [G]

inherit
	EL_AUDIO_SAMPLE_LIST
	
	ARRAYED_LIST [G]
		rename
			count as sample_count
		end

end