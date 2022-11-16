note
	description: "Waveform format"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_WAVEFORM_FORMAT

inherit
	MANAGED_POINTER
		rename
			make as make_pointer
		export
			{NONE} all
			{ANY} item
		end

	EL_WAVEFORM_FORMAT_ABS undefine copy, is_equal end

	EL_MULTIMEDIA_SYSTEM_C_API undefine copy, is_equal end

create
	make, make_default, make_16_bit_mono_PCM

feature {NONE} -- Initialization

	make_default
			--
		do
			make_pointer (c_size_of_wave_formatex)
		end

	make (header: EL_AUDIO_WAVE_HEADER)
		do
			make_default
			set_samples_per_sec (header.samples_per_sec)
			set_bits_per_sample (header.bits_per_sample)
			set_format (header.format)
			set_num_channels (header.num_channels)
			set_block_align
			set_average_bytes_per_sec
			set_extra_format_info_size (0)
		end

	make_16_bit_mono_PCM (samples_per_sec_count: INTEGER)
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

	make_pcm
			--
		do
			make_default
			set_format (PCM_format)
			set_extra_format_info_size (0)
		end

feature -- Access

	buffer_size_for_duration (milliseconds: INTEGER): INTEGER
			-- Buffer size required for duration of milliseconds
		local
			samples_in_duration_count: INTEGER
		do
			samples_in_duration_count := (milliseconds.to_real * samples_per_sec.to_real / 1000.0).rounded
			Result := samples_in_duration_count * block_align
		end

	format: INTEGER_16
			--
		do
			Result := c_format (item).to_integer_16
		end

	num_channels : INTEGER
			--
		do
			Result := c_num_channels (item)
		end

	samples_per_sec: INTEGER
			--
		do
			Result := c_samples_per_sec (item)
		end

	bits_per_sample: INTEGER
			--
		do
			Result := c_bits_per_sample (item)
		end

	average_bytes_per_sec: INTEGER
			--
		do
			Result := c_average_bytes_per_sec (item)
		end

	block_align: INTEGER
			--
		do
			Result := c_block_align (item)
		end

feature -- Element change

	set_format (a_format: INTEGER)
			--
		require
			valid_format: is_valid_format (a_format)
		do
			c_set_format (item, a_format)
		end

	set_num_channels (number: INTEGER)
			--
		do
			c_set_num_channels (item, number)
		end

	set_samples_per_sec (samples_per_sec_count: INTEGER)
			--
		do
			c_set_samples_per_sec (item, samples_per_sec_count)
		end

	set_bits_per_sample (bits: INTEGER)
			--
		do
			c_set_bits_per_sample (item, bits)
		end

	set_extra_format_info_size (size_byte_count: INTEGER)
			--
		do
			c_set_cb_size (item, size_byte_count)
		end

	set_block_align
			--
		do
			c_set_block_align (item, num_channels * bits_per_sample // 8)
		end

	set_average_bytes_per_sec
			--
		do
			c_set_average_bytes_per_sec (item, samples_per_sec * block_align)
		end

invariant

	valid_average_bytes_per_sec: c_average_bytes_per_sec (item) = c_samples_per_sec (item) * c_block_align (item)

	valid_block_align: c_block_align (item) = c_num_channels (item) * c_bits_per_sample (item) // 8

end