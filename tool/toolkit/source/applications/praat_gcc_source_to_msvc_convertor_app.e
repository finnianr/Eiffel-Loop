note
	description: "${description}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 19:58:26 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP

inherit
	FILE_TREE_OPERATING_SUB_APP
		redefine
			Option_name, normal_initialize, Installer
		end

	EVOLICITY_SERIALIZEABLE
		rename
			template as build_batch_file_template,
			make as make_serializeable
		export
			{NONE} all
		end

	EL_MODULE_DIRECTORY
		export
			{NONE} all
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_TEXTUAL_PATTERN_FACTORY
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	normal_initialize
			--
		do
			Precursor
			make_serializeable
			directory_content_processor.set_input_dir (tree_path)

			create directory_content_processor.make
			Args.set_string_from_word_option (
				"dest_dir", agent set_destination_path,
				Execution_environment.variable_dir_path ("EIFFEL_LOOP").joined_dir_steps (<< "C_library", "Praat-MSVC" >>).to_string
			)

			directory_content_processor.do_all (agent set_version_from_path, "praat.c")

			if attached {STRING} praat_version_no as version_no then
				create make_file_parser.make

				create converter_table.make (5)
				converter_table.compare_objects

				converter_table ["default"] := create {GCC_TO_MSVC_CONVERTER}.make
				converter_table ["praat.c"] := create {FILE_PRAAT_C_GCC_TO_MSVC_CONVERTER}.make
				converter_table ["motifEmulator.c"] := create {FILE_MOTIF_EMULATOR_C_GCC_TO_MSVC_CONVERTER}.make
				converter_table ["gsl__config.h"] := create {FILE_GSL_CONFIG_H_GCC_TO_MSVC_CONVERTER}.make
				converter_table ["NUM2.c"] := create {FILE_NUM2_C_GCC_TO_MSVC_CONVERTER}.make
			else
				log.put_line ("ERROR: Failed to determine version number from source directory!")
			end
		end

feature -- Basic operations

	normal_run
			--
		local
			build_all_batch_file: EL_FILE_PATH
			batch_file_name: EL_ASTRING
		do
			if attached {STRING} praat_version_no as version_no then
				directory_content_processor.do_all (agent convert_make_file, "Makefile")
				directory_content_processor.do_all (agent convert_c_source_file , "*.h")
				directory_content_processor.do_all (agent convert_c_source_file , "*.c")

				batch_file_name := "build_all_" + praat_version_no + ".bat"
				build_all_batch_file := directory_content_processor.output_dir + batch_file_name

				serialize_to_file (build_all_batch_file)
			end
		end

feature -- Test

	test_run
			--
		do
		end

feature {NONE} -- Evolicity access

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["c_library_name_list",	 agent: ITERABLE [STRING] do Result := make_file_parser.c_library_name_list end],
				["praat_version_no",		 agent: STRING do Result := praat_version_no end]
			>>)
		end

feature -- Element change

	set_praat_version_no (text: EL_STRING_VIEW)
			--
		do
			praat_version_no := text
		end

	set_destination_path (a_path: EL_ASTRING)
			--
		do
			directory_content_processor.set_output_dir (
				Directory.path (a_path).joined_dir_path (directory_content_processor.input_dir.base)
			)
		end

	set_version_from_path (
		input_file_path: EL_FILE_PATH; output_directory: EL_DIR_PATH
		input_file_name, input_file_extension: STRING
	)
			--
		local
			path_processor: EL_SOURCE_TEXT_PROCESSOR
		once
			log.enter_with_args ("set_version_from_path", << output_directory >>)
			create path_processor.make_with_delimiter (
				all_of (<<
					character_literal (Operating_environment.Directory_separator),
					string_literal ("sources_"),
					repeat (character_in_range ('0', '9'), 4 |..| 4) |to| agent set_praat_version_no
				>>)
			)
			path_processor.set_source_text (output_directory.to_string)
			path_processor.do_all
			log.exit
		end

feature {NONE} -- Basic operations

	convert_make_file (
		input_file_path: EL_FILE_PATH; output_directory: EL_DIR_PATH
		input_file_name, input_file_extension: STRING
	)
			--
		do
			log.enter_with_args ("convert_makefile", << input_file_path, output_directory, input_file_name >>)
			make_file_parser.new_c_library (input_file_path)

			log.put_string (input_file_path.out)
			log.put_new_line

			if make_file_parser.c_library.is_valid then
				log.put_string_field ("Library name" , make_file_parser.c_library.library_name)
				log.put_new_line
				log.put_integer_field (
					"Number of include directories" , make_file_parser.c_library.include_directory_list.count
				)
				log.put_new_line
				log.put_integer_field ("Number of C objects" , make_file_parser.c_library.object_file_list.count)
				log.put_new_line

				make_file_parser.c_library.set_praat_version_no (praat_version_no)
				make_file_parser.c_library.serialize_to_file (output_directory + input_file_name)
			end

			log.exit
		end

	convert_c_source_file (
		input_file_path: EL_FILE_PATH; output_directory: EL_DIR_PATH
		input_file_name, input_file_extension: STRING
	)
			--
		local
			output_file_path: EL_FILE_PATH
			converter: GCC_TO_MSVC_CONVERTER
			source_name: STRING
		do
			log.enter_with_args ("convert_c_source_file", << input_file_path, output_directory, input_file_name >>)

			output_file_path := input_file_name
			output_file_path.add_extension (input_file_extension)

			create source_name.make_from_string (input_file_name)
			source_name.append_character ('.')
			source_name.append (input_file_extension)

			converter_table.search (source_name)
			if converter_table.found then
				converter := converter_table.found_item
			else
				converter := converter_table ["default"]
			end

			converter.set_input_file_path (input_file_path)
			converter.set_output_file_path (output_directory + output_file_path)
			converter.edit_text

			log.exit
		end

feature {NONE} -- Implementation

	directory_content_processor: EL_DIRECTORY_CONTENT_PROCESSOR

	make_file_parser: PRAAT_MAKE_FILE_PARSER

	converter_table: HASH_TABLE [GCC_TO_MSVC_CONVERTER, STRING]

	praat_version_no: STRING

feature {NONE} -- Constants

	build_batch_file_template: STRING =
		--
	"[
		Rem DO NOT EDIT
		Rem Generated by Eiffel-LOOP build tool from class PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP

		set INCLUDE=%MSVC%\include;%PLATFORM_SDK%\Include;%EIFFEL_LOOP%\C_library\dirent\include
		set LIB=%LIB%;%PLATFORM_SDK%\Lib;%MSVC%\lib

		#foreach $directory in $c_library_name_list loop
		cd sources_$praat_version_no\$directory
		nmake /f Makefile
		cd ..\..
		#end
		echo FINISHED!
		pause
	]"

	Option_name: STRING = "praat_to_msvc"

	Description: STRING = "Convert Praat C source file directory and make file to compile with MS Visual C++"

	Installer: EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER
		once
			create Result.make ("Eiffel Loop/Development/Convert Praat source for Visual C++")
		end

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP}, "*"],
				[{EVOLICITY_ENGINE}, "*"],
				[{FILE_PRAAT_C_GCC_TO_MSVC_CONVERTER}, "*"],
				[{PROCEDURE_PRAAT_RUN_GCC_TO_MSVC_CONVERTER}, "*"]
			>>
		end

end
