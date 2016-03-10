note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_AUDIO_WAVE_HEADER

inherit
	SED_MEMORY_READER_WRITER
		rename
			make as make_writer
		export
			{NONE} all
		end

	EL_WAVEFORM_FORMAT_ABS
		export
			{NONE} all
			{ANY} ID_fmt
		end

	EL_WINDOWS_AUDIO_API

	EL_MODULE_LOG

create
	make, make_empty, make_from_other

feature {NONE} -- Initialization

	make_empty
			--
		do
			make_with_buffer (create {MANAGED_POINTER}.make (Standard_header_size))
			create extra_header_chunks.make (7)
		end

	make_from_other (other: EL_AUDIO_WAVE_HEADER)
			--
		do
			make_empty
			make (other.num_channels, other.bits_per_sample // Bits_per_byte, other.samples_per_sec)
			extra_header_chunks.merge (other.extra_header_chunks)
		end

	make (a_num_channels, sample_bytes, a_samples_per_sec : INTEGER)
			--
		do
			make_empty
			num_channels := a_num_channels
			bits_per_sample := sample_bytes * Bits_per_byte
			samples_per_sec := a_samples_per_sec
			format := PCM_format
			set_block_align
			set_average_bytes_per_sec
			size := Standard_header_size
		end

feature -- Basic operations

	write_to_file (file: EL_WAVE_FILE)
			--
		require
			file_is_open: file.is_open_write
		do
			if not extra_header_chunks.is_empty then
				make_with_buffer (create {MANAGED_POINTER}.make (Standard_header_size + extra_header_chunks_size))
			end
			create_header
			file.go (0)
			file.put_managed_pointer (buffer, 0, buffer_size)
		end

	read_from_file (file: EL_WAVE_FILE)
			--
		require
			file_is_open: file.is_open_read
		local
			chunk: EL_WAV_FORMAT_CHUNK
			chunk_id: STRING
		do
			from
				chunk_id := read_chunk_id (file)
				chunk := read_chunk (chunk_id, file)
				size := size + chunk.size
			until
				chunk_id.is_equal (ID_data)
			loop
				if chunk_id.is_equal (ID_fmt) then
					set_format_from_chunk (chunk)
				end
				chunk_id := read_chunk_id (file)
				chunk := read_chunk (chunk_id, file)
				if not standard_header_IDs.has (chunk.id) then
					extra_header_chunks [chunk.id] := chunk
				end
				size := size + chunk.size
			end
			check
				is_data_chunk: chunk.id.is_equal (ID_data)
			end
			read_data_size (chunk)
		end

feature -- Element change

	set_bits_per_sample (a_bits_per_sample: like bits_per_sample)
			-- Set `bits_per_sample' to `a_bits_per_sample'.
		do
			bits_per_sample := a_bits_per_sample
		ensure
			bits_per_sample_assigned: bits_per_sample = a_bits_per_sample
		end

	set_samples_per_sec (a_samples_per_sec: like samples_per_sec)
			-- Set `samples_per_sec' to `a_samples_per_sec'.
		do
			samples_per_sec := a_samples_per_sec
		ensure
			samples_per_sec_assigned: samples_per_sec = a_samples_per_sec
		end

	set_num_channels (a_num_channels: like num_channels)
			-- Set `num_channels' to `a_num_channels'.
		do
			num_channels := a_num_channels
		ensure
			num_channels_assigned: num_channels = a_num_channels
		end

	set_sample_count (a_sample_count: INTEGER)
			--
		do
			sample_count := a_sample_count
			data_size := sample_count * block_align
			duration := (sample_count / samples_per_sec).truncated_to_real
		end

feature -- Access

	bits_per_sample: INTEGER

	block_align: INTEGER

	average_bytes_per_sec: INTEGER

	samples_per_sec: INTEGER

	num_channels: INTEGER

	format: INTEGER_16

	data_size: INTEGER
			-- Size in bytes

	sample_count: INTEGER

	duration: REAL

	size: INTEGER

	extra_header_chunks: HASH_TABLE [EL_WAV_FORMAT_CHUNK, STRING]

feature -- Conversion

	to_c_struct: MANAGED_POINTER
			--
		do
			create Result.make (c_size_of_wave_formatex)
			c_set_average_bytes_per_sec (Result.item, average_bytes_per_sec)
			c_set_samples_per_sec (Result.item, samples_per_sec)
			c_set_bits_per_sample (Result.item, bits_per_sample)
			c_set_block_align (Result.item, block_align)
			c_set_format (Result.item, format)
			c_set_num_channels (Result.item, num_channels)
			c_set_size_byte_count (Result.item, 0)
		end

feature {NONE} -- Implementation

	create_header
			--	Create a WAV File BigEndian  C structure
			-- (Standard Microsoft Header)

			--		struct soundhdr {
			--			char riff[4]; /* "RIFF" */
			--			long flength; /* file length in bytes */
			--			char wave[4]; /* "WAVE" */
			--			char fmt[4]; /* "fmt " */
			--			long block_size; /* in bytes (generally 16) */
			--			short format_tag; /* 1=PCM, 257=Mu-Law, 258=A-Law, 259=ADPCM */
			--			short num_chans; /* 1=mono, 2=stereo */
			--			long srate; /* Sampling rate in samples per second */
			--			long bytes_per_sec; /* bytes per second */
			--			short bytes_per_samp; /* 2=16-bit mono, 4=16-bit stereo */
			--			short bits_per_samp; /* Number of bits per sample */
			--			char data[4]; /* "data" */
			--			long dlength; /* data length in bytes (filelength - 44) */
			--		};
		require
			num_channels_set: num_channels /= 0
			bits_per_sample_set: bits_per_sample /= 0
			samples_per_sec_set: samples_per_sec /= 0
		do
			is_little_endian_storable := true
			count := 0
			set_for_writing
			set_block_align

			write_id 			(ID_RIFF)
			write_integer_32 	(Standard_header_size + data_size - 8 + extra_header_chunks_size)
			write_id			(ID_WAVE)
			write_id 			(ID_fmt)
			write_integer_32 	(Size_of_WAVE_chunk_section)
			write_integer_16 	(format)
			write_integer_16 	(num_channels.to_integer_16)
			write_integer_32 	(samples_per_sec)
			write_integer_32 	(average_bytes_per_sec)
			write_integer_16 	(block_align.to_integer_16)
			write_integer_16 	(bits_per_sample.to_integer_16)

			if not extra_header_chunks.is_empty then
				write_header_chunks
			end

			write_id 			(ID_data)
			write_integer_32 	(data_size)
		ensure
			buffer_position_valid: count = Standard_header_size + extra_header_chunks_size
		end

	write_header_chunks
			--
		local
			l_pos: INTEGER
			chunk_item: EL_WAV_FORMAT_CHUNK
			chunk_data: ARRAY [NATURAL_8]
		do
			from extra_header_chunks.start until extra_header_chunks.after loop
				chunk_item := extra_header_chunks.item_for_iteration
				write_id (chunk_item.id)
				write_integer_32 (chunk_item.data_size)
				l_pos := count
				chunk_data := chunk_item.buffer.read_array (
					0, chunk_item.data_size
				)
				if chunk_item.word_alignment_pad_byte = 1 then
					chunk_data.force (0, chunk_data.count + 1)
				end
				check_buffer (chunk_data.count)
				buffer.put_array (chunk_data, l_pos)
				l_pos := l_pos + chunk_data.count
				count := l_pos
				extra_header_chunks.forth
			end
		end

	write_id (id: STRING)
			-- Write `id'.
		require
			valid_id_size: id.count = 4
			is_ready: is_ready_for_writing
			id_not_void: id /= Void
		local
			i: INTEGER
		do
			from i := 1 until i > 4 loop
				write_character_8 (id.item (i))
				i := i + 1
			end
		end

feature -- Element change

	set_format_from_chunk (chunk: EL_WAV_FORMAT_CHUNK)
			--	Read WAV File BigEndian C structure

			-- struct fmt {
			--		char fmt[4]; 				// "fmt "
			--		long block_size; 			// in bytes (generally 16)
			--		short format_tag; 			// 1=PCM, 257=Mu-Law, 258=A-Law, 259=ADPCM
			--		short num_chans; 			// 1=mono, 2=stereo
			--		long srate; 				// Sampling rate in samples per second
			--		long bytes_per_sec; 		// bytes per second
			--		short bytes_per_samp; 		// 2=16-bit mono, 4=16-bit stereo
			--		short bits_per_samp; 		// Number of bits per sample
			-- };

		require
			is_format_chunk: chunk.id.is_equal (ID_fmt)
		do
			format := chunk.read_integer_16 -- Wave_format_pcm.to_integer_16
			num_channels := chunk.read_integer_16
			samples_per_sec := chunk.read_integer_32
			average_bytes_per_sec := chunk.read_integer_32
			block_align := chunk.read_integer_16
			bits_per_sample := chunk.read_integer_16
		end

feature {NONE} -- Implementation: read operations		

	read_data_size (chunk: EL_WAV_FORMAT_CHUNK)
			--	
		require
			is_format_chunk: chunk.id.is_equal (ID_data)
		do
			data_size := chunk.data_size
			sample_count := data_size // block_align
			duration := (sample_count / samples_per_sec).truncated_to_real
		end

	read_chunk_id (file: EL_WAVE_FILE): STRING
			--
		local
			i: INTEGER
		do
			create Result.make (Size_of_chunk_id)
			from i := 1 until i > Size_of_chunk_id loop
				file.read_character
				Result.append_character (file.last_character)
				i := i + 1
			end
		end

	read_chunk (an_id: STRING; file: EL_WAVE_FILE): EL_WAV_FORMAT_CHUNK
			--
		do
			create Result.make (an_id, file)
		end

	extra_header_chunks_size: INTEGER
			--
		do
			from
				extra_header_chunks.start
			until
				extra_header_chunks.after
			loop
				Result := Result + extra_header_chunks.item_for_iteration.size
				extra_header_chunks.forth
			end
		end

	set_block_align
			--
		do
			block_align := (bits_per_sample // 8) * num_channels
		end

	set_average_bytes_per_sec
			--
		do
			average_bytes_per_sec := block_align * samples_per_sec
		end

feature {NONE} -- Constants

	Standard_header_IDs: ARRAY [STRING]
			--
		once
			Result := << ID_data, ID_wave, ID_fmt >>
			Result.compare_objects
		end

	Bits_per_byte: INTEGER = 8

end

