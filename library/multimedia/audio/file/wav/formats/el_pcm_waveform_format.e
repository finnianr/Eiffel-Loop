note
	description: "Pcm waveform format"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_PCM_WAVEFORM_FORMAT

inherit
	EL_WAVEFORM_FORMAT
		rename
			make as make_waveform
		end

feature {NONE} -- Initialization

	make
			--
		do
			make_waveform
			set_format (PCM_format)
			set_size_byte_count (0)
		end

end
