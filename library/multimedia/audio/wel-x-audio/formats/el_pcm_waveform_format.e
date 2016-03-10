note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

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

