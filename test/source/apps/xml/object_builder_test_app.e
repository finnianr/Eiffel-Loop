note
	description: "Test conversion of SMIL and XHTML documents to Eiffel and serialization back to XML."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-13 13:02:13 GMT (Monday 13th November 2017)"
	revision: "8"

class
	OBJECT_BUILDER_TEST_APP

inherit
	REGRESSION_TESTABLE_SUB_APPLICATION
		redefine
			Option_name, initialize
		end

create
	make

feature {NONE} -- Initiliazation

	initialize
			--
		do
			Precursor
			smart_builder := new_smart_builder
		end

feature -- Basic operations

	test_run
			--
		do
			-- Jan 2016
			Test.do_file_test ("XML/creatable/linguistic-analysis.smil", agent build_and_serialize_file, 1808379658)
			Test.do_all_files_test ("XML/creatable", "*", agent build_and_serialize_file, 908662685)
			Test.do_file_test ("XML/creatable/download-page.xhtml", agent build_and_serialize_file, 519114799)
			Test.do_all_files_test ("XML/creatable", "*", agent smart_build_file, 562742021)
		end

feature -- Tests

	build_and_serialize_file (file_path: EL_FILE_PATH)
			--
		local
			extension: STRING
		do
			extension := file_path.extension.to_latin_1
			if extension ~ "xhtml" then
				read_and_save (file_path, create {WEB_FORM}.make_from_file (file_path))

			elseif extension ~ "smil" then
				read_and_save (file_path, create {SMIL_PRESENTATION}.make_from_file (file_path))

			elseif file_path.to_string.has_substring ("matrix") then
				operate_on_matrix (file_path)

			end
		end

	operate_on_matrix (file_in_path: EL_FILE_PATH)
			--
		local
			matrix: MATRIX_CALCULATOR
		do
			log.enter_with_args ("operate_on_matrix", << file_in_path.to_string >>)
			create matrix.make_from_file (file_in_path)
			matrix.find_column_sum
			matrix.find_column_average
			log.exit
		end

	read_and_save (file_path: EL_FILE_PATH; constructed_object: EVOLICITY_SERIALIZEABLE_AS_XML)
			--
		do
			log.enter_with_args ("read_and_save", << file_path.to_string >>)
			constructed_object.save_as_xml (file_path)
			log.exit
		end

	smart_build_file (file_path: EL_FILE_PATH)
			--
		do
			log.enter_with_args ("smart_build_file", << file_path >>)
			smart_builder.build_from_file (file_path)

			if attached {EL_FILE_PERSISTENT_BUILDABLE_FROM_XML} smart_builder.target as storable then
				storable.set_output_path (file_path)
				storable.store
			end
			log.exit
		end

	new_smart_builder: EL_SMART_BUILDABLE_FROM_NODE_SCAN
		do
			create {EL_SMART_XML_TO_EIFFEL_OBJECT_BUILDER} Result.make
		end

feature {NONE} -- Internal attributes

	smart_builder: like new_smart_builder

feature {NONE} -- Constants

	Description: STRING
		once
			Result := "Auto test conversion of SMIL and XHTML documents to Eiffel and serialization back to XML"
		end

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{OBJECT_BUILDER_TEST_APP}, All_routines],
				[{SMIL_AUDIO_SEQUENCE}, All_routines],
				[{SMIL_AUDIO_CLIP}, All_routines],
				[{SMIL_PRESENTATION}, All_routines],
				[{WEB_FORM}, All_routines],
				[{WEB_FORM_COMPONENT}, All_routines],
				[{WEB_FORM_DROP_DOWN_LIST}, All_routines],
				[{WEB_FORM_TEXT}, All_routines],
				[{WEB_FORM_LINE_BREAK}, All_routines],
				[{MATRIX_CALCULATOR}, "find_column_sum, find_column_average, set_calculation_procedure, add_row, -add_row_col"]
			>>
		end

	Option_name: STRING
			--
		once
			Result := "object_builder"
		end

end
