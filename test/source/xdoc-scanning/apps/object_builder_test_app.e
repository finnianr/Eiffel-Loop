note
	description: "Test conversion of SMIL and XHTML documents to Eiffel and serialization back to XML."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-06 11:34:32 GMT (Monday 6th January 2020)"
	revision: "10"

class
	OBJECT_BUILDER_TEST_APP

inherit
	TEST_SUB_APPLICATION
		redefine
			Option_name, initialize, visible_types
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
			-- Jan 2020
--			Test.do_file_test ("XML/creatable/linguistic-analysis.smil", agent build_and_serialize_file, 2094778673)
--			Test.do_all_files_test ("XML/creatable", "*", agent build_and_serialize_file, 2148677303)
--			Test.do_file_test ("XML/creatable/download-page.xhtml", agent build_and_serialize_file, 557006133)
			Test.do_all_files_test ("XML/creatable", "*", agent smart_build_file, 562742021)
		end

feature -- Tests

	build_and_serialize_file (file_path: EL_FILE_PATH)
			--
		local
			extension: STRING
		do
			log.enter_with_args ("build_and_serialize_file", [file_path])
			extension := file_path.extension.to_latin_1
			if extension ~ "xhtml" then
				read_and_save (file_path, create {WEB_FORM}.make_from_file (file_path))

			elseif extension ~ "smil" then
				read_and_save (file_path, create {SMIL_PRESENTATION}.make_from_file (file_path))

			elseif file_path.to_string.has_substring ("matrix") then
				operate_on_matrix (file_path)
			end
			log.exit
		end

	new_smart_builder: EL_SMART_BUILDABLE_FROM_NODE_SCAN
		do
			create {EL_SMART_XML_TO_EIFFEL_OBJECT_BUILDER} Result.make
		end

	operate_on_matrix (file_in_path: EL_FILE_PATH)
			--
		local
			matrix: MATRIX_CALCULATOR
		do
			log.enter_with_args ("operate_on_matrix", [file_in_path])
			create matrix.make_from_file (file_in_path)
			matrix.find_column_sum
			matrix.find_column_average
			log.exit
		end

	read_and_save (file_path: EL_FILE_PATH; constructed_object: EVOLICITY_SERIALIZEABLE_AS_XML)
			--
		do
			log.enter_with_args ("read_and_save", [file_path])
			constructed_object.save_as_xml (file_path)
			log.exit
		end

	smart_build_file (file_path: EL_FILE_PATH)
			--
		do
			log.enter_with_args ("smart_build_file", [file_path])
			smart_builder.build_from_file (file_path)

			if attached {EL_FILE_PERSISTENT_BUILDABLE_FROM_XML} smart_builder.target as storable then
				storable.set_output_path (file_path)
				storable.store
			end
			log.exit
		end

feature {NONE} -- Implementation

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{OBJECT_BUILDER_TEST_APP}, All_routines]
			>>
		end

	visible_types: TUPLE [
		WEB_FORM, WEB_FORM_DROP_DOWN_LIST, WEB_FORM_COMPONENT, WEB_FORM_LINE_BREAK,
		SMIL_AUDIO_SEQUENCE, SMIL_AUDIO_CLIP, SMIL_PRESENTATION,
		MATRIX_CALCULATOR
	]
		do
			create Result
		end

feature {NONE} -- Internal attributes

	smart_builder: like new_smart_builder

feature {NONE} -- Constants

	Description: STRING
		once
			Result := "Auto test conversion of SMIL and XHTML documents to Eiffel and serialization back to XML"
		end

	Option_name: STRING
			--
		once
			Result := "object_builder"
		end

end
