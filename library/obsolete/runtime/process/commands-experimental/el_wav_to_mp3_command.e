note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_WAV_TO_MP3_COMMAND

inherit
	EL_DOUBLE_OPERAND_FILE_SYSTEM_COMMAND [EL_WAV_TO_MP3_IMPL]
		rename
			source_path as input_file_path,
			destination_path as output_file_path,

			set_source_path as set_input_file_path,
			set_destination_path as set_output_file_path,

			make as make_double_operand_command

		redefine
			input_file_path, output_file_path
		end

	EL_MODULE_ENVIRONMENT

	EL_MODULE_LOG

	EL_MODULE_DIRECTORY

create
	make

feature {NONE} -- Initialization

	make (a_source_path, a_destination_path: like input_file_path; latin1_encoding: BOOLEAN)
			--
		do
			make_double_operand_command (a_source_path, a_destination_path)
			is_path_latin1 := latin1_encoding
			bit_rate_per_channel := Default_bit_rate_per_channel
			num_channels := Default_num_channels
			create title.make_empty
			create genre.make_empty
			create comment.make_empty
			create album.make_empty
			create artist.make_empty
			year := 1
		end

feature -- Element change

	set_num_channels (a_num_channels: like num_channels)
			-- Set `num_channels' to `a_mode'.
		require
			valid_num_channels: (1 |..| 2).has (a_num_channels)
		do
			num_channels := a_num_channels
		end

	set_bit_rate_per_channel (a_bit_rate_per_channel: INTEGER)
			--
		do
			bit_rate_per_channel := a_bit_rate_per_channel
		end

	set_title (a_title: like title)
			--
		do
			title := a_title
		end

	set_artist (a_artist: like artist)
			--
		do
			artist := a_artist
		end

	set_album (a_album: like album)
			--
		do
			album := a_album
		end

	set_year (a_year: like year)
			--
		do
			year := a_year
		end

	set_genre (a_genre: like genre)
			--
		do
			genre := a_genre
		end

	set_comment (a_comment: like comment)
			--
		do
			comment := a_comment
		end

feature -- Access

	output_file_path: EL_FILE_PATH

	input_file_path: EL_FILE_PATH

	num_channels: INTEGER

	bit_rate_per_channel: INTEGER

	bit_rate: INTEGER
			--
		do
			Result := num_channels * bit_rate_per_channel
		end

	title: STRING

	artist: STRING

	album: STRING

	year: INTEGER

	genre: STRING

	comment: STRING

	mode: STRING
			--
		do
			Result := Mode_letters.item (num_channels).out
		end

feature {NONE} -- Evolicity reflection

	get_title: like title
			--
		do
			Result := escaped_argument (title)
		end

	get_artist: like artist
			--
		do
			Result := escaped_argument (artist)
		end

	get_album: like album
			--
		do
			Result := escaped_argument (album)
		end

	get_year: REAL_REF
			--
		do
			Result := year.to_real.to_reference
		end

	get_genre: like genre
			--
		do
			Result := escaped_argument (genre)
		end

	get_comment: like comment
			--
		do
			Result := escaped_argument (comment)
		end

	get_bit_rate: REAL_REF
			--
		do
			Result := bit_rate.to_real.to_reference
		end

feature {NONE} -- Constants

	Mode_letters: ARRAY [CHARACTER]
			-- mono or stereo
		once
			Result := << 'm', 's' >>
		end

	Default_bit_rate_per_channel: INTEGER = 64
			-- Kilo bits per sec

	Default_num_channels: INTEGER = 1

end
