note
	description: "[
		Tool to convert Praat C source file directory and make file to compile with MS Visual C++
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-10 10:17:00 GMT (Tuesday 10th November 2020)"
	revision: "9"

class
	PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR]
		redefine
			Option_name
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("source_tree", "Praat C source tree", << directory_must_exist >>),
				optional_argument ("output_dir", "Output directory for MS VC compatible code")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (
				"", execution.variable_dir_path ("EIFFEL_LOOP").joined_dir_path ("C_library/Praat-MSVC")
			)
		end

	log_filter_set: EL_LOG_FILTER_SET [
		PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP,
		FILE_PRAAT_C_GCC_TO_MSVC_CONVERTER,
		PROCEDURE_PRAAT_RUN_GCC_TO_MSVC_CONVERTER
	]
			--
		do
			 create Result.make
		end

feature {NONE} -- Constants

	Option_name: STRING = "praat_to_msvc"

	Description: STRING = "Convert Praat C source file directory and make file to compile with MS Visual C++"

end