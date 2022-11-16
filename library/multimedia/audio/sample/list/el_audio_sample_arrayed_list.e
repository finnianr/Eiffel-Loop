note
	description: "Audio sample arrayed list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

deferred class
	EL_AUDIO_SAMPLE_ARRAYED_LIST [G]

inherit
	EL_AUDIO_SAMPLE_LIST
	
	ARRAYED_LIST [G]
		rename
			count as sample_count
		end

end