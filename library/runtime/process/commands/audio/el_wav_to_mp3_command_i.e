note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-23 7:36:15 GMT (Thursday 23rd June 2016)"
	revision: "5"

deferred class
	EL_WAV_TO_MP3_COMMAND_I

inherit
	EL_FILE_CONVERSION_COMMAND_I
		redefine
			make_default, getter_function_table, valid_input_extension, valid_output_extension
		end

	EL_MULTIMEDIA_CONSTANTS

feature {NONE} -- Initialization

	make_default
			--
		do
			album := Unknown; artist := Unknown; title := Unknown
			bit_rate_per_channel := Default_bit_rate_per_channel
			num_channels := Default_num_channels
			Precursor
		end

feature -- Element change

	set_album (a_album: like album)
		do
			album := a_album
		end

	set_artist (a_artist: like artist)
		do
			artist := a_artist
		end

	set_bit_rate_per_channel (a_bit_rate_per_channel: INTEGER)
			--
		do
			bit_rate_per_channel := a_bit_rate_per_channel
		end

	set_num_channels (a_num_channels: like num_channels)
			-- Set `num_channels' to `a_mode'.
		require
			valid_number_channels: valid_number_channels (a_num_channels)
		do
			num_channels := a_num_channels
		end

	set_title (a_title: like title)
		do
			title := a_title
		end

feature -- Access

	bit_rate: INTEGER
			--
		do
			Result := num_channels * bit_rate_per_channel
		end

	bit_rate_per_channel: INTEGER

	num_channels: INTEGER

feature -- ID3 fields

	album: STRING

	artist: STRING

	title: STRING

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["bit_rate",	agent: REAL_REF do Result := bit_rate.to_real.to_reference end],
				["mode", 		agent: STRING do Result := Mode_letters.item (num_channels).out end],

				-- ID3 fields
				["album", 		agent: STRING do Result := album end],
				["artist", 		agent: STRING do Result := artist end],
				["title", 		agent: STRING do Result := title end]
			>>)
		end

feature -- Contract Support

	valid_number_channels (a_num_channels: like num_channels): BOOLEAN
		do
			Result := (1 |..| 2).has (a_num_channels)
		end

	valid_input_extension (extension: ZSTRING): BOOLEAN
		do
			Result := extension ~ File_extension_wav
		end

	valid_output_extension (extension: ZSTRING): BOOLEAN
		do
			Result := extension ~ File_extension_mp3
		end

feature {NONE} -- Constants

	Default_bit_rate_per_channel: INTEGER = 64
			-- Kilo bits per sec

	Default_num_channels: INTEGER = 2

	Mode_letters: ARRAY [CHARACTER]
			-- mono or stereo
		once
			Result := << 'm', 's' >>
		end

feature -- Constants

	Unknown: STRING = "Unknown"

end