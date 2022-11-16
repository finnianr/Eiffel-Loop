note
	description: "16 bit audio sample arrayed list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

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