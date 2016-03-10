note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "2"

class
	EL_16_BIT_AUDIO_SAMPLE_ARRAYED_LIST

inherit
	EL_AUDIO_SAMPLE_ARRAYED_LIST [INTEGER_16]

create
	make

feature {NONE} -- Implementation

	normalized_item: REAL
			--
		do
			Result := (item / (item.max_value + 1)).truncated_to_real
		end

end
