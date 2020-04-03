note
	description: "Audio sample arrayed list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-03 14:10:47 GMT (Friday 3rd April 2020)"
	revision: "5"

deferred class
	EL_AUDIO_SAMPLE_ARRAYED_LIST [G]

inherit
	EL_AUDIO_SAMPLE_LIST
	
	ARRAYED_LIST [G]
		rename
			count as sample_count
		end

end