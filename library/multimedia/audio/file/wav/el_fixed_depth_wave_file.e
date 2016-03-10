note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_FIXED_DEPTH_WAVE_FILE [SAMPLE_TYPE -> EL_AUDIO_PCM_SAMPLE create make end]

inherit
	EL_WAVE_FILE
		rename
			make_open_write as make_file_open_write,
			make_create_read_write as file_make_create_read_write,
			make as make_closed
		end

create
	make_create_read_write, make_open_read, make_create_read_write_from_header

feature {NONE} -- Initialization

	make_create_read_write (file_name: STRING; a_num_channels, a_samples_per_sec: INTEGER)
			--
		do
			file_make_create_read_write (file_name)
			make_sample_source (a_num_channels)
			internal_sample := create {SAMPLE_TYPE}.make
			create header.make (a_num_channels, sample_bytes, a_samples_per_sec)
			put_header
			create_last_sample_blocks
		end

	make_create_read_write_from_header (file_name: STRING; a_header: EL_AUDIO_WAVE_HEADER)
			--
		do
			file_make_create_read_write (file_name)
			header := a_header
			make_sample_source (header.num_channels)
			internal_sample := create {SAMPLE_TYPE}.make
			put_header
			create_last_sample_blocks
		end

end
