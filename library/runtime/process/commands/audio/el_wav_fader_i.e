note
	description: "Summary description for {EL_WAV_FADER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-02 9:34:51 GMT (Saturday 2nd December 2017)"
	revision: "3"

deferred class
	EL_WAV_FADER_I

inherit
	EL_FILE_CONVERSION_COMMAND_I
		redefine
			getter_function_table, valid_input_extension, valid_output_extension
		end

	EL_MULTIMEDIA_CONSTANTS

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

	fade_out: REAL

feature -- Contract Support

	valid_input_extension (extension: ZSTRING): BOOLEAN
		do
			Result := extension ~ File_extension_wav
		end

	valid_output_extension (extension: ZSTRING): BOOLEAN
		do
			Result := extension ~ File_extension_wav
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor +
				["fade_in",				 agent: REAL_REF do Result := fade_in.to_reference end] +
				["duration", 			 agent: REAL_REF do Result := duration.to_reference end] +
				["fade_out", 			 agent: REAL_REF do Result := fade_out.to_reference end]
		end

end
