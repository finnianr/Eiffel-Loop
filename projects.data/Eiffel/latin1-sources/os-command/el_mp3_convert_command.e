indexing
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2010 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "1 March 2010"
	revision: "0.2"

class
	EL_MP3_CONVERT_COMMAND

inherit
	EL_DOUBLE_OPERAND_FILE_SYSTEM_OS_COMMAND [EL_MP3_CONVERT_IMPL]
		rename
			source_path as input_file_path,
			destination_path as output_file_path,

			set_source_path as set_input_file_path,
			set_destination_path as set_output_file_path,

			get_source_path as get_input_file_path,
			get_destination_path as get_output_file_path

		redefine
			Getter_functions, make, input_file_path, output_file_path
		end

	EL_MODULE_ENVIRONMENT

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make (a_source_path, a_destination_path: like input_file_path) is
			--
		do
			Precursor (a_source_path, a_destination_path)
			bit_rate_per_channel := Default_bit_rate_per_channel
			num_channels := Default_num_channels
		end

feature -- Not element change

	set_num_channels (a_num_channels: like num_channels) is
			-- Set `num_channels' to `a_mode'.
		require
			valid_num_channels: (1 |..| 2).has (a_num_channels)
		do
			num_channels := a_num_channels
		end

	set_bit_rate_per_channel (a_bit_rate_per_channel: INTEGER) is
			--
		do
			bit_rate_per_channel := a_bit_rate_per_channel
		end

feature -- Access @title : STRING

	output_file_path: FILE_NAME

	input_file_path: FILE_NAME

	num_channels: INTEGER

	bit_rate_per_channel: INTEGER

	bit_rate: INTEGER is
			--
		do
			Result := num_channels * bit_rate_per_channel
		end

feature {NONE} -- Constants

	Mode_letters: ARRAY [CHARACTER] is
			-- mono or stereo
		once
			Result := << 'm', 's' >>
		end

	Default_bit_rate_per_channel: INTEGER is 64
			-- Kilo bits per sec

	Default_num_channels: INTEGER is 1

feature {NONE} -- Evolicity reflection

	get_bit_rate: REAL_REF is
			--
		do
			Result := bit_rate.to_real.to_reference
		end

	get_mode: STRING is
			--
		do
			Result := Mode_letters.item (num_channels).out
		end

	Getter_functions: EVOLICITY_GETTER_FUNCTION_TABLE is
			--
		once
			create Result.make (<<
				["input_file_path", agent get_input_file_path],
				["output_file_path", agent get_output_file_path],
				["bit_rate", agent get_bit_rate],
				["mode", agent get_mode]
			>>)
		end
		
end
