note
	description: "Pcm waveform format"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:05 GMT (Saturday 19th May 2018)"
	revision: "3"

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
