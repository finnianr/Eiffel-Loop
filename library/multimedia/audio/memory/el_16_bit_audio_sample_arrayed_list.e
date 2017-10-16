note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
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