note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 8:06:06 GMT (Wednesday 16th December 2015)"
	revision: "5"

class
	EL_WAV_TO_MP3_COMMAND

inherit
	EL_DOUBLE_OPERAND_FILE_SYSTEM_OS_COMMAND [EL_WAV_TO_MP3_IMPL]
		rename
			source_path as input_file_path,
			destination_path as output_file_path,

			set_source_path as set_input_file_path,
			set_destination_path as set_output_file_path,

			make as make_double_operand_command,

			Valid_extension as File_extension_wav,
			Valid_destination_extension as File_extension_mp3
		undefine
			File_extension_wav, File_extension_mp3
		redefine
			getter_function_table, output_file_path
		end

	EL_MULTIMEDIA_CONSTANTS
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make (a_source_path, a_destination_path: like input_file_path)
			--
		do
			make_double_operand_command (a_source_path, a_destination_path)
			bit_rate_per_channel := Default_bit_rate_per_channel
			num_channels := Default_num_channels
		end

feature -- Element change

	set_num_channels (a_num_channels: like num_channels)
			-- Set `num_channels' to `a_mode'.
		require
			valid_number_channels: valid_number_channels (a_num_channels)
		do
			num_channels := a_num_channels
		end

	set_bit_rate_per_channel (a_bit_rate_per_channel: INTEGER)
			--
		do
			bit_rate_per_channel := a_bit_rate_per_channel
		end

feature -- Access

	num_channels: INTEGER

	bit_rate_per_channel: INTEGER

	bit_rate: INTEGER
			--
		do
			Result := num_channels * bit_rate_per_channel
		end

	output_file_path: EL_FILE_PATH

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["input_file_path", 		agent: ZSTRING do Result := escaped_path (input_file_path) end],
				["output_file_path", 	agent: ZSTRING do Result := escaped_path (output_file_path) end],

				["bit_rate",				agent: REAL_REF do Result := bit_rate.to_real.to_reference end],
				["mode", 					agent: STRING do Result := Mode_letters.item (num_channels).out end]
			>>)
		end

feature -- Contract Support

	valid_number_channels (a_num_channels: like num_channels): BOOLEAN
		do
			Result := (1 |..| 2).has (a_num_channels)
		end

feature {NONE} -- Constants

	Mode_letters: ARRAY [CHARACTER]
			-- mono or stereo
		once
			Result := << 'm', 's' >>
		end

	Default_bit_rate_per_channel: INTEGER = 64
			-- Kilo bits per sec

	Default_num_channels: INTEGER = 2

feature -- Constants

	Valid_input_file_path_extension: ZSTRING
		once
			Result := "wav"
		end

	Valid_output_file_path_extension: ZSTRING
		once
			Result := "mp3"
		end

end
