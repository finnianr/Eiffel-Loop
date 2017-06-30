note
	description: "[
		Tool to convert Praat C source file directory and make file to compile with MS Visual C++
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 9:43:16 GMT (Thursday 29th June 2017)"
	revision: "2"

class
	PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [input_dir, output_dir: EL_DIR_PATH]
		do
			create Result
			Result.input_dir := ""
			Result.output_dir := Execution_environment.variable_dir_path ("EIFFEL_LOOP").joined_dir_path ("C_library/Praat-MSVC")
		end

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("source_tree", "Praat C source tree", << directory_must_exist >>),
				optional_argument ("output_dir", "Output directory for MS VC compatible code")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "praat_to_msvc"

	Description: STRING = "Convert Praat C source file directory and make file to compile with MS Visual C++"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			 Result := <<
				[{PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP}, All_routines],
				[{FILE_PRAAT_C_GCC_TO_MSVC_CONVERTER}, All_routines],
				[{PROCEDURE_PRAAT_RUN_GCC_TO_MSVC_CONVERTER}, All_routines]
			>>
		end

end
