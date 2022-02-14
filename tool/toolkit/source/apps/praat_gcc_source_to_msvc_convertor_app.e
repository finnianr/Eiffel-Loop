note
	description: "[
		Command line interface to [$source PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR] which is a
		tool to convert Praat C source file directory and make file to compile with MS Visual C++
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-14 12:26:27 GMT (Monday 14th February 2022)"
	revision: "14"

class
	PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP

inherit
	EL_LOGGED_COMMAND_LINE_APPLICATION [PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR]
		redefine
			Option_name
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("source_tree", "Praat C source tree", << directory_must_exist >>),
				optional_argument ("output_dir", "Output directory for MS VC compatible code", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (
				"", execution.variable_dir_path ("EIFFEL_LOOP") #+ "C_library/Praat-MSVC"
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

end