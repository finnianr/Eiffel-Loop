note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_WAV_FORMAT_CHUNK

inherit
	SED_MEMORY_READER_WRITER
		rename
			make as make_memory_reader
		export
			{NONE} all
			{ANY} read_integer_32, read_integer_16, read_integer_8, is_for_reading
			{ANY} write_integer_32, write_integer_16, write_integer_8
			{EL_AUDIO_WAVE_HEADER} buffer
		end

	EL_WAV_FORMAT_CONSTANTS
		rename
			Size_of_chunk_id as Size_of_id
		end

	EL_MODULE_LOG

	PLATFORM

create
	make, make_with_size_for_writing

feature {NONE} -- Initialization

	make (an_id: STRING; file: EL_WAVE_FILE)
			--
		require
			id_correct_size: an_id.count = Size_of_id
			file_is_open: file.is_open_read
		do
			id := an_id
			if not id.is_equal (ID_wave) then
				file.read_integer
				data_size := file.last_integer
				if not set (<<ID_riff, ID_data>>).has (id) then
					make_with_buffer (create {MANAGED_POINTER}.make (data_size))
					file.read_to_managed_pointer (buffer, 0, data_size)
					if Word_alignment_pad_byte = 1 then
						file.read_integer_8
					end
					is_little_endian_storable := true
					count := 0
					set_for_reading
				end
			end
		end

	make_with_size_for_writing (an_id: STRING; a_data_size: INTEGER)
			--
		require
			id_correct_size: an_id.count = Size_of_id
		do
			create id.make_from_string (an_id)
			data_size := a_data_size
			make_with_buffer (create {MANAGED_POINTER}.make (data_size))
			is_little_endian_storable := true
			count := 0
			set_for_writing
		end

feature -- Access

	id: STRING

	size: INTEGER
			--
		do
			Result := Size_of_id
			if not id.is_equal (ID_wave) then
				Result := Result + Integer_32_bytes
				if not set (<<ID_riff, ID_data>>).has (id) then
					Result := Result + data_size + Word_alignment_pad_byte
				end
			end
		end

	data_size: INTEGER

	Word_alignment_pad_byte: INTEGER
			--
		do
			Result := data_size \\ 2
		end

feature -- Element change

	read_from_start
			--
		do
			count := 0
		end

	write_integer_16_array (integers: ARRAY [INTEGER_16])
			--
		do
			if natural_16_bytes * integers.count + count > buffer_size then
				log.enter ("write_integer_16_array")
				log.put_line ("Format chunk not big enough")
				log.put_integer_field ("data_size", data_size)
				log.put_new_line
				log.exit
			else
				integers.do_all (agent write_integer_16)
			end
		end

feature {NONE} -- Implementation

	set (ids: ARRAY [STRING]): ARRAY [STRING]
			--
		do
			Result := ids
			Result.compare_objects
		end

end
