note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_WAVE_FILE

inherit
	RAW_FILE
		rename
			close as close_file,
			make_open_write as file_make_open_write
		export
			{NONE} all
			{ANY}
				is_open_write, is_open_read,
				extendible, name, exists,
				open_write, open_append, open_read_write

			{EL_AUDIO_WAVE_HEADER}
				put_managed_pointer, go, read_character, last_character

			{EL_WAV_FORMAT_CHUNK, EL_AUDIO_WAVE_HEADER}
				read_integer, last_integer, read_to_managed_pointer, read_integer_8
		redefine
			make_open_read
		end

	EL_AUDIO_IO_MEDIUM
		rename
			make as make_sample_source,
			sample_count as sample_block_count,
			num_channels as num_sample_source_channels
		end

	EL_MODULE_LOG

create
	make_open_read, make_open_write

feature {NONE} -- Initialization

	make_open_write (file_name: STRING; a_num_channels, a_sample_bytes, a_samples_per_sec : INTEGER)
			--
		do
			file_make_open_write (file_name)
			create header.make (a_num_channels, a_sample_bytes, a_samples_per_sec)
		end

	make_open_read (file_name: STRING)
			--
		do
			Precursor (file_name)
			create header.make_empty
			header.read_from_file (Current)
			make_sample_source (header.num_channels)
			sample_block_count := header.sample_count
			duration := header.duration
			inspect header.bits_per_sample
				when 8 then
					create {EL_8_BIT_AUDIO_PCM_SAMPLE} internal_sample.make

				when 16 then
					create {EL_16_BIT_AUDIO_PCM_SAMPLE} internal_sample.make

				when 32 then
					create {EL_32_BIT_AUDIO_PCM_SAMPLE} internal_sample.make
			end
			create_last_sample_blocks
		end

	create_last_sample_blocks
			--
		do
			create last_sample_block_integer.make (1, num_channels)
			create last_sample_block_double.make (1, num_channels)
			create last_sample_block_real.make (1, num_channels)
		end

feature -- Basic operations

	process_at_sample_rate (sample_rate: INTEGER)
			-- Process sample_file with processor at sample_rate (samples/sec)
		local
			process_sample_count, i, channel: INTEGER
			unit_relative_pos: REAL
		do
			log.enter ("process_at_sample_rate")
			process_sample_count := (duration * sample_rate).rounded.min (sample_block_count)

			do_all_channels (agent {EL_AUDIO_SAMPLE_PROCESSOR}.set_sample_count (sample_block_count))
			do_all_channels (agent {EL_AUDIO_SAMPLE_PROCESSOR}.set_samples_per_sec (samples_per_sec))

			go_sample (1)
			do_all_channels (agent {EL_AUDIO_SAMPLE_PROCESSOR}.on_start)

			from i := 1 until i > process_sample_count loop
				unit_relative_pos := (i / process_sample_count).truncated_to_real
				go_sample_at_relative_pos (unit_relative_pos)
				read_sample_block_integer
				from channel := 1 until channel > num_channels loop
					processors.item (channel).do_with_sample_at_time (
						last_sample_block_integer [channel], i, unit_relative_pos * duration
					)
					channel := channel + 1
				end
				i := i + 1
			end
			do_all_channels (agent {EL_AUDIO_SAMPLE_PROCESSOR}.on_finish)
			close
			log.exit
		end

	process_all
			-- Process all sample_file
		require else
			is_open_read: is_open_read
		local
			channel, i: INTEGER
		do
			log.enter ("process_all")

			do_all_channels (agent {EL_AUDIO_SAMPLE_PROCESSOR}.set_sample_count (sample_block_count))
			do_all_channels (agent {EL_AUDIO_SAMPLE_PROCESSOR}.set_samples_per_sec (samples_per_sec))

			go_sample (1)
			do_all_channels (agent {EL_AUDIO_SAMPLE_PROCESSOR}.on_start)

			from i := 1 until i > sample_block_count loop
				read_sample_block_integer
				from channel := 1 until channel > num_channels loop
					processors.item (channel).do_with_sample (last_sample_block_integer [channel], i)
					channel := channel + 1
				end
				i := i + 1
			end
			do_all_channels (agent {EL_AUDIO_SAMPLE_PROCESSOR}.on_finish)
			close
			log.exit
		end

	close
			--
		do
			if sample_block_count /= header.sample_count then
				put_header
			end
			close_file
		end

	write_unit_double_samples_to_text_file (text_file_name: STRING)
			--
		local
			text_file: PLAIN_TEXT_FILE
			i, channel: INTEGER
			format_double: FORMAT_DOUBLE
		do
			create format_double.make (9, 6)
			create text_file.make_open_write (text_file_name)
			if is_closed then
				open_read
			end
			go_sample (1)
			from i := 1 until i > sample_block_count loop
				read_sample_block_double
				from channel := 1 until channel > num_channels loop
					text_file.put_string (format_double.formatted (last_sample_block_double [channel]))
					text_file.put_new_line
					channel := channel + 1
				end
				i := i + 1
			end
			text_file.close
			close
		end

feature -- Input

	read_sample_block_integer
			--
		local
			i: INTEGER
		do
			from i := 1 until i > num_channels loop
				read_to_managed_pointer (internal_sample, 0, internal_sample.bytes)
				last_sample_block_integer [i] := internal_sample.value
				i := i + 1
			end
		end

	read_sample_block_double
			--
		local
			i: INTEGER
		do
			from i := 1 until i > num_channels loop
				read_to_managed_pointer (internal_sample, 0, internal_sample.bytes)
				last_sample_block_double [i] := internal_sample.to_double_unit
				i := i + 1
			end
		end

	read_sample_block_real
			--
		local
			i: INTEGER
		do
			from i := 1 until i > num_channels loop
				read_to_managed_pointer (internal_sample, 0, internal_sample.bytes)
				last_sample_block_real [i] := internal_sample.to_real_unit
				i := i + 1
			end
		end

feature -- Access

	header: EL_AUDIO_WAVE_HEADER

	samples_per_sec: INTEGER
			--
		do
			Result := header.samples_per_sec
		end

	sample_block_position: INTEGER
			--
		do
			Result := (position - header.size) // sample_block_size + 1
		end

feature -- Cursor movement

	go_sample_at_relative_pos (unit_relative_pos: REAL)
			--
		require
			is_unit: unit_relative_pos.sign >= 0 and unit_relative_pos <= 1.0
		do
			go_sample (1 + (unit_relative_pos * (sample_block_count - 1)).rounded)
		end

	go_sample (index: INTEGER)
			--
		require
			header_not_void: header /= Void
			is_open_read: is_open_read
			valid_index: index >= 1
		do
			go (header.size + (index - 1) * sample_block_size )
		end

feature -- Access

	sample_block_count: INTEGER

	sample_block_size: INTEGER
			-- Combined size of samples for all channels
		do
			Result := internal_sample.Bytes * num_channels
		end

	last_sample_block_integer: ARRAY [INTEGER]

	last_sample_block_double: ARRAY [DOUBLE]

	last_sample_block_real: ARRAY [REAL]

	unit_sample_block_array_double (lower, upper: INTEGER): EL_PCM_SAMPLE_BLOCK_ARRAY [DOUBLE]
			--
		local
			i: INTEGER
		do
			create Result.make (lower, upper, num_channels)

			go_sample (lower)
			from i := lower until i > upper loop
				read_sample_block_double
				Result.put (last_sample_block_double, i)
				i := i + 1
			end
		end

	unit_sample_array_double (channel, lower, upper: INTEGER): ARRAY [DOUBLE]
			--
		local
			i: INTEGER
		do
			create Result.make (lower, upper)

			go_sample (lower)
			from i := lower until i > upper loop
				read_sample_block_double
				Result.put (last_sample_block_double [channel], i)
				i := i + 1
			end
		end

	num_channels: INTEGER
			--
		do
			Result := header.num_channels
		end

feature -- Element change

	put_unit_sample_block_array_double (samples: EL_PCM_SAMPLE_BLOCK_ARRAY [DOUBLE])
			--
		require
			valid_number_of_channels: samples.num_channels = num_channels
			exists: exists
			is_writeable: is_open_write
		local
			i: INTEGER
		do
			go_sample (samples.lower)

			check
				right_position: header.size + (samples.lower - 1) * sample_block_size = position
			end

			from i := samples.lower until i > samples.upper loop
				put_unit_double_sample_block (samples.item (i))
				i := i + 1
			end
			sample_block_count := samples.upper
		end

	put_unit_sample_array_on_channel_double (samples: ARRAY [DOUBLE]; channel: INTEGER)
			--
		require
			exists: exists
			is_writeable: is_open_write
			valid_channel: channel <= num_channels
		local
			i: INTEGER
		do
			go_sample (samples.lower)

			check
				right_position: header.size + (samples.lower - 1) * sample_block_size = position
			end

			move ((channel - 1) * internal_sample.bytes)
			from i := samples.lower until i > samples.upper loop
				internal_sample.set_from_double_unit (samples [i])
				put_managed_pointer (internal_sample, 0, internal_sample.bytes)
				move ((num_channels - 1) * internal_sample.bytes)
				i := i + 1
			end
			sample_block_count := samples.upper
		end

	put_unit_real_sample_block (sample_block: ARRAY [REAL])
			--
		require
			valid_number_of_channels: sample_block.count = num_channels
		local
			channel: INTEGER
		do
			from channel := 1 until channel > num_channels loop
				internal_sample.set_from_real_unit (sample_block [channel])
				put_managed_pointer (internal_sample, 0, internal_sample.bytes)
				channel := channel + 1
			end
			sample_block_count := sample_block_count + 1
		end

	put_unit_double_sample_block (sample_block: ARRAY [DOUBLE])
			--
		require
			valid_number_of_channels: sample_block.count = num_channels
		local
			channel: INTEGER
		do
			from channel := 1 until channel > num_channels loop
				internal_sample.set_from_double_unit (sample_block [channel])
				put_managed_pointer (internal_sample, 0, internal_sample.bytes)
				channel := channel + 1
			end
			sample_block_count := sample_block_count + 1
		end

	put_sample_block (sample_block: ARRAY [INTEGER])
			--
		require
			valid_number_of_channels: sample_block.count = num_channels
		local
			channel: INTEGER
		do
			from channel := 1 until channel > num_channels loop
				internal_sample.set_value (sample_block [channel])
				put_managed_pointer (internal_sample, 0, internal_sample.bytes)
				channel := channel + 1
			end
			sample_block_count := sample_block_count + 1
		end

	put_normalised_real_samples_from_channel_files (real_sample_files: ARRAY [EL_MONO_UNITIZED_SAMPLE_FILE])
			--
		require
			one_for_each_channels: real_sample_files.count = num_channels
			real_sample_file_is_open:
				real_sample_files.linear_representation.for_all (agent {EL_MONO_UNITIZED_SAMPLE_FILE}.is_open_read)
			extendible: extendible
		local
			i, channel: INTEGER
			l_sample_block: ARRAY [REAL]
		do
			log.enter ("write_normalised_real_samples")
			create l_sample_block.make (1, real_sample_files.count)
			open_append
			from i := 1 until i > sample_block_count loop
				from channel := 1 until channel > num_channels loop
					real_sample_files.item (channel).read_real
					l_sample_block [channel] := (real_sample_files.item (channel).last_normalised_sample).truncated_to_real
					channel := channel + 1
				end
				put_unit_real_sample_block (l_sample_block)
				i := i + 1
			end
			close
			log.put_integer_field ("sample_block_count", sample_block_count)
			log.put_new_line
			log.exit
		end

	put_other_file (other: EL_WAVE_FILE)
			--
		require
			other_is_open_read: other.is_open_read
		local
			i: INTEGER
		do
			other.go_sample (1)
			from i := 1 until i > other.sample_block_count loop
				other.read_sample_block_integer
				put_sample_block (other.last_sample_block_integer)
				i := i + 1
			end
		end

	put_raw_sample_data (sample_data: MANAGED_POINTER)
			--
		do
			put_managed_pointer (sample_data, 0, sample_data.count)
			sample_block_count := sample_block_count + sample_data.count // (sample_bytes * num_channels)
		end

	put_header
			--
		require
			is_open_read_write: is_open_write
		do
			log.enter ("write_header")
			start
			header.set_sample_count (sample_block_count)
			header.write_to_file (Current)
			log.exit
		end

feature {EL_WAVE_FILE} -- Implementation

	internal_sample: EL_AUDIO_PCM_SAMPLE
		-- Current internal_sample

	sample_bytes: INTEGER
			--
		do
			Result := internal_sample.Bytes
		end

end
