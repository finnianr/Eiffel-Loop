note
	description: "[
		Sequence of PCM audio data blocks implemented as C arrays.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
	EL_AUDIO_SAMPLE_SOURCE [SAMPLE_TYPE -> EL_AUDIO_PCM_SAMPLE create make end]

inherit
	LINEAR [MANAGED_POINTER]
		rename
			item as data_item
		end

feature {NONE} -- Initialization

	make (a_header: EL_AUDIO_WAVE_HEADER)
			--
		do
			create {SAMPLE_TYPE} internal_sample.make
			header := a_header
		end

feature -- Access

	num_channels: INTEGER

	data_item_sample_count: INTEGER
			--
		do
			Result := data_item.count // header.block_align
		end

	header: EL_AUDIO_WAVE_HEADER

	data_item: MANAGED_POINTER

feature -- Cursor movement

	go_relative_position (unit_relative_pos: REAL)
			--
		require
			is_unit: unit_relative_pos.sign >= 0 and unit_relative_pos <= 1.0
		deferred
		end

feature {NONE} -- Element change

	set_data_item_from_unit_double_sample_block_array (block_array: EL_PCM_SAMPLE_BLOCK_ARRAY [DOUBLE])
			--
		require
			same_number_of_channels: block_array.num_channels = num_channels
		local
			i, ch_i: INTEGER
			sample_block: ARRAY [DOUBLE]
			sample_ptr: POINTER
		do
			create data_item.make (block_array.count * num_channels * internal_sample.bytes)
			sample_ptr := data_item.item
			from i := block_array.lower until i > block_array.upper loop
				sample_block := block_array.item (i)
				from ch_i := 1 until ch_i > block_array.num_channels loop
					internal_sample.set_from_double_unit (sample_block [ch_i])
					sample_ptr.memory_copy (internal_sample.item, internal_sample.Bytes)
					ch_i := ch_i + 1
					sample_ptr := sample_ptr + internal_sample.Bytes
				end
				i := i + 1
			end
		end

	set_data_item_from_unit_sample_segment_channels (segment_channels: EL_MULTICHANNEL_AUDIO_UNIT_SAMPLE_ARRAY [DOUBLE])
			--
		require
			same_number_of_channels: segment_channels.count = num_channels
		local
			i, ch_i: INTEGER
			sample_ptr: POINTER
			sample_interval: INTEGER_INTERVAL
		do
			create data_item.make (segment_channels.sample_count * num_channels * internal_sample.bytes)
			sample_ptr := data_item.item
			sample_interval := segment_channels.sample_interval

			from i := sample_interval.lower until i > sample_interval.upper loop
				from ch_i := 1 until ch_i > num_channels loop
					internal_sample.set_from_double_unit (segment_channels [ch_i].item (i))
					sample_ptr.memory_copy (internal_sample.item, internal_sample.Bytes)
					ch_i := ch_i + 1
					sample_ptr := sample_ptr + internal_sample.Bytes
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	internal_sample: SAMPLE_TYPE
		-- 8, 16 or 32 bit

end
