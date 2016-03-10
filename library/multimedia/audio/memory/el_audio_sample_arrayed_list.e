note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "2"

deferred class
	EL_AUDIO_SAMPLE_ARRAYED_LIST [G]

inherit
	EL_AUDIO_SAMPLE_LIST
	
	ARRAYED_LIST [G]
		rename
			count as sample_count
		end

end
