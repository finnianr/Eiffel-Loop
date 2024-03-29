note
	description: "Wave sample file abs"
	notes: "[
		**TO DO**
		
		Performance optimizations:
		
		1. Use compact ${INTEGER_64} intervals instead of ${INTEGER_INTERVAL}
		2. Use ${SPECIAL [REAL]} instead of ${ARRAY [REAL]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-21 13:00:27 GMT (Sunday 21st January 2024)"
	revision: "7"

deferred class
	EL_WAVE_SAMPLE_FILE_ABS

inherit
	RAW_FILE
		rename
			make as make_file
		export
			{NONE} all
			{ANY} move, open_read, close, open_write, open_append, is_closed
		redefine
			open_read
		end

feature {NONE} -- Initialization

	make (fn: STRING; a_num_channels: INTEGER)
			--		WAV BigEndian File C structure

		do
			make_file (fn)
			create last_sample_block.make (1, a_num_channels)
			sample := new_sample
			sample_block_count := (count - Size_of_header) // sample_block_size
		end

feature -- Status setting

	open_read
			--
		do
			Precursor
			go (Size_of_header)
		end

feature -- Cursor movement

	move_to_relative_pos (unit_relative_pos: REAL)
			--
		local
			file_offset: INTEGER
		do
			file_offset := Size_of_header + (unit_relative_pos * sample_block_count).rounded * sample.byte_count
			move (file_offset - position)
		end

	move_to_sample_on_channel (index, channel: INTEGER)
			--
		local
			file_offset: INTEGER
		do
			file_offset := Size_of_header + (index - 1 * sample_block_size) + sample.byte_count * (channel - 1)
			move (file_offset - position)
		end

feature -- Access

	last_sample_block: ARRAY [INTEGER]

	num_channels: INTEGER
		do
			Result := last_sample_block.count
		end

	sample_block_count: INTEGER

	sample_block_size: INTEGER
		-- Combined size of samples for all channels
		do
			Result := sample.byte_count * num_channels
		end

	unit_double_samples_segment_for_channel (channel: INTEGER; interval: INTEGER_INTERVAL): ARRAY [DOUBLE]
		-- Unitized samples for channel
		-- Zero padded to make up full interval length
		local
			i: INTEGER
		do
			create Result.make (interval.lower, interval.upper)
			from i := interval.lower until i > interval.upper loop
				if i <= sample_block_count then
					move_to_sample_on_channel (i, channel)
					sample.read_from (Current)
					Result [i] := sample.to_double_unit
				else
					Result [i] := 0.0
				end
				i := i + 1
			end
		end

	unit_sample_segment_for_channel_real (channel: INTEGER; interval: INTEGER_INTERVAL): ARRAY [REAL]
			--
		local
			i: INTEGER
		do
			create Result.make (interval.lower, interval.upper)
			from i := interval.lower until i > interval.upper loop
				move_to_sample_on_channel (i, channel)
				sample.read_from (Current)
				Result [i] := sample.to_real_unit
				i := i + 1
			end
		end

feature -- Element change

	put_sample_block (sample_block: ARRAY [INTEGER])
			--
		require
			valid_number_of_channels: sample_block.count = num_channels
		local
			i: INTEGER
		do
			from i := 1 until i > num_channels loop
				sample.set_value (sample_block [i])
				sample.write_to (Current)
				i := i + 1
			end
		end

	put_unit_sample_block (sample_block: ARRAY [REAL])
			--
		require
			valid_number_of_channels: sample_block.count = num_channels
		local
			i: INTEGER
		do
			from i := 1 until i > num_channels loop
				sample.set_from_real_unit (sample_block [i])
				sample.write_to (Current)
				i := i + 1
			end
		end

	put_unit_sample_channel_segments (segment_array: ARRAY [ARRAY [DOUBLE]])
			--
		require
			valid_number_of_channels: segment_array.count = num_channels
		local
			i, channel: INTEGER
		do
			from i := 1 until i > num_channels loop
				from channel := 1 until channel > num_channels loop
					sample.set_from_double_unit (segment_array.item (i).item (channel))
					sample.write_to (Current)
					channel := channel + 1
				end
				i := i + 1
			end
		end

feature -- Basic operations

	read_sample_block
			--
		local
			i: INTEGER
		do
			from i := 1 until i > num_channels loop
				sample.read_from (Current)
				last_sample_block [i] := sample.value
				i := i + 1
			end
		end

feature {NONE} -- Factory

	new_sample: EL_AUDIO_PCM_SAMPLE
			--
		deferred
		end

feature {NONE} -- Internal attributes

	sample: EL_AUDIO_PCM_SAMPLE
		-- Current sample

feature -- Constants

	Size_of_header: INTEGER = 44

end