note
	description: "16Bit mono pcm wave format"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_16BIT_MONO_PCM_WAVE_FORMAT

inherit
	EL_PCM_WAVEFORM_FORMAT
		rename
			make as make_pcm
		end
		
create
	make
	
feature {NONE} -- Initialization

	make (samples_per_sec_count: INTEGER)
			--
		do
			make_pcm
			set_num_channels (1)
			set_bits_per_sample (16)
			set_samples_per_sec (samples_per_sec_count)

			set_block_align
			set_average_bytes_per_sec
		ensure
			average_bytes_per_sec_valid: average_bytes_per_sec = samples_per_sec * block_align
			block_align_valid: block_align = num_channels * bits_per_sample // 8
		end

end
