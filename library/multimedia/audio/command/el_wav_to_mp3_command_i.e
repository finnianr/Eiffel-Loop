note
	description: "Wav to mp3 command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-09 16:05:56 GMT (Thursday 9th September 2021)"
	revision: "8"

deferred class
	EL_WAV_TO_MP3_COMMAND_I

inherit
	EL_FILE_CONVERSION_COMMAND_I
		redefine
			make_default, execute, getter_function_table, valid_input_extension, valid_output_extension
		end

	EL_MULTIMEDIA_CONSTANTS

	EL_MODULE_CONSOLE

feature {NONE} -- Initialization

	make_default
			--
		do
			album := Unknown; artist := Unknown; title := Unknown
			bit_rate_per_channel := Default_bit_rate_per_channel
			num_channels := Default_num_channels
			Precursor
		end

feature -- Basic operations

	execute
			--
		require else
			valid_code_page: valid_code_page
		do
			Precursor
		end

feature -- Element change

	set_album (a_album: READABLE_STRING_GENERAL)
		do
			create album.make_from_general (a_album)
		end

	set_artist (a_artist: READABLE_STRING_GENERAL)
		do
			create artist.make_from_general (a_artist)
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

	set_title (a_title: READABLE_STRING_GENERAL)
		do
			create title.make_from_general (a_title)
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

	album: ZSTRING

	artist: ZSTRING

	title: ZSTRING

feature -- Status query

	valid_code_page: BOOLEAN
		do
			Result := {PLATFORM}.is_unix implies Console.code_page ~ "UTF-8"
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor +
				["bit_rate",	agent: REAL_REF do Result := bit_rate.to_real.to_reference end] +
				["mode", 		agent: STRING do Result := Mode_letters.item (num_channels).out end] +

				-- ID3 fields
				["album", 		agent: ZSTRING do Result := album end] +
				["artist", 		agent: ZSTRING do Result := artist end] +
				["title", 		agent: ZSTRING do Result := title end]
		end

feature -- Contract Support

	valid_input_extension (extension: ZSTRING): BOOLEAN
		do
			Result := extension ~ Media_extension.wav
		end

	valid_number_channels (a_num_channels: like num_channels): BOOLEAN
		do
			Result := (1 |..| 2).has (a_num_channels)
		end

	valid_output_extension (extension: ZSTRING): BOOLEAN
		do
			Result := extension ~ Media_extension.mp3
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