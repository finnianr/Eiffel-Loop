note
	description: "Summary description for {EL_WAV_FADER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:00 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_WAV_FADER

inherit
	EL_DOUBLE_OPERAND_FILE_SYSTEM_OS_COMMAND [EL_WAV_FADER_IMPL]
		rename
			source_path as input_file_path,
			destination_path as output_file_path,

			set_source_path as set_input_file_path,
			set_destination_path as set_output_file_path,

			make as make_double_operand_command,

			Valid_extension as File_extension_wav,
			Valid_destination_extension as File_extension_wav
		undefine
			File_extension_wav
		redefine
			getter_function_table, output_file_path
		end

	EL_MULTIMEDIA_CONSTANTS

	EL_MODULE_ENVIRONMENT

	EL_MODULE_LOG

	EL_MODULE_DIRECTORY

create
	make

feature {NONE} -- Initialization

	make (a_source_path, a_destination_path: like input_file_path)
			--
		do
			make_double_operand_command (a_source_path, a_destination_path)
		end

feature -- Element change

	set_fade_in (a_fade_in: like fade_in)
		do
			fade_in := a_fade_in
		end

	set_duration (a_duration: like duration)
		do
			duration := a_duration
		end

	set_fade_out (a_fade_out: like fade_out)
		do
			fade_out := a_fade_out
		end

feature -- Access

	fade_in: REAL

	duration: REAL
		--

	fade_out: REAL

	output_file_path: EL_FILE_PATH

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["input_file_path",	 agent: EL_ASTRING do Result := escaped_path (input_file_path) end],
				["output_file_path",	 agent: EL_ASTRING do Result := escaped_path (output_file_path) end],
				["fade_in",				 agent: REAL_REF do Result := fade_in.to_reference end],
				["duration", 			 agent: REAL_REF do Result := duration.to_reference end],
				["fade_out", 			 agent: REAL_REF do Result := fade_out.to_reference end]
			>>)
		end

end
