note
	description: "Convert Praat gcc C source code to compile with MSVC"
	notes: "[
		Tested with [https://www.fon.hum.uva.nl/praat/old/src/sources_4430.zip Praat version 4.4.3]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-04 18:00:36 GMT (Sunday 4th December 2022)"
	revision: "18"

class
	PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR

inherit
	EL_APPLICATION_COMMAND
		redefine
			error_check
		end

	EL_DIRECTORY_CONTENT_PROCESSOR [EL_OS_COMMAND_FILE_OPERATION]
		export
			{NONE} all
		redefine
			make
		end

	EL_MODULE_FILE; EL_MODULE_LIO

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_input_dir, a_output_dir: DIR_PATH)
		do
			create praat_version_no.make_empty
			create output_directory_text.make_empty
			Precursor (a_input_dir, a_output_dir #+ a_input_dir.base)

			c_header_list := new_path_list (Source_type.c_header)

			c_header_list.find_first_base (Praat_version_h)
			if c_header_list.found then
--				#define PRAAT_VERSION 4.4.30
				praat_version_no := File.line_one (c_header_list.path).split (' ').last
			else
				create praat_version_no.make_empty
			end
			create make_file_parser.make

			create converter_table.make (<<
				[Default_key,			create {GCC_TO_MSVC_CONVERTER}.make],
				["praat.c",				create {FILE_PRAAT_C_GCC_TO_MSVC_CONVERTER}.make],
				["motifEmulator.c",	create {FILE_MOTIF_EMULATOR_C_GCC_TO_MSVC_CONVERTER}.make],
				["gsl__config.h",		create {FILE_GSL_CONFIG_H_GCC_TO_MSVC_CONVERTER}.make],
				["NUM2.c",				create {FILE_NUM2_C_GCC_TO_MSVC_CONVERTER}.make]
			>>)
		end

feature -- Constants

	Description: STRING = "Convert Praat C source file directory and make file to compile with MS Visual C++"

feature -- Basic operations

	execute
			--
		local
			build_script: PRAAT_BUILD_SCRIPT
		do
			do_with (agent convert_c_source_file, c_header_list)
			do_all (agent convert_c_source_file, Source_type.c_source)

			do_all (agent convert_make_file, Source_type.make_file)
			create build_script.make (make_file_parser.c_library_name_list, output_dir, praat_version_no)
			build_script.serialize
		end

	error_check (application: EL_FALLIBLE)
		-- check for errors before execution
		do
			if praat_version_no.is_empty then
				application.put_error_message ("Failed to determine version number from " + Praat_version_h)
			end
		end

feature {NONE} -- Implementation

	convert_c_source_file (input_file_path, output_file_path: FILE_PATH)
			--
		local
			converter: GCC_TO_MSVC_CONVERTER
		do
			lio.enter_with_args ("convert_c_source_file", [input_file_path, output_file_path])

			if converter_table.has_key (input_file_path.base) then
				converter := converter_table.found_item
			else
				converter := converter_table [Default_key]
			end

			converter.set_input_file_path (input_file_path)
			converter.set_output_file_path (output_file_path)
			converter.edit

			lio.exit
		end

	convert_make_file (input_file_path, output_file_path: FILE_PATH)
			--
		do
			lio.enter_with_args ("convert_makefile", [input_file_path, output_file_path])
			make_file_parser.new_c_library (input_file_path)

			lio.put_string (input_file_path.out)
			lio.put_new_line

			if make_file_parser.c_library.is_valid then
				lio.put_string_field ("Library name" , make_file_parser.c_library.library_name)
				lio.put_new_line
				lio.put_integer_field (
					"Number of include directories" , make_file_parser.c_library.include_directory_list.count
				)
				lio.put_new_line
				lio.put_integer_field ("Number of C objects" , make_file_parser.c_library.object_file_list.count)
				lio.put_new_line

				make_file_parser.c_library.set_praat_version_no (praat_version_no)
				make_file_parser.c_library.serialize_to_file (output_file_path)
			end
			lio.exit
		end

feature {NONE} -- Internal attributes

	converter_table: EL_ZSTRING_HASH_TABLE [GCC_TO_MSVC_CONVERTER]

	make_file_parser: PRAAT_MAKE_FILE_PARSER

	output_directory_text: ZSTRING

	c_header_list: like new_path_list

	praat_version_no: STRING

feature {NONE} -- Constants

	Default_key: ZSTRING
		once
			Result := "default"
		end

	Praat_source: ZSTRING
		once
			Result := "praat.c"
		end

	Praat_version_h: ZSTRING
		once
			Result := "praat_version.h"
		end

	Source_type: TUPLE [make_file, c_header, c_source: ZSTRING]
		once
			create Result
			Result.make_file := "Makefile"
			Result.c_header := "*.h"
			Result.c_source := "*.c"
		end

end