note
	description: "Test conversion of SMIL and XHTML documents to Eiffel and serialization back to XML."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 10:53:24 GMT (Wednesday 8th January 2020)"
	revision: "12"

class
	OBJECT_BUILDER_TEST_APP

inherit
	TEST_SUB_APPLICATION
		redefine
			Option_name, visible_types
		end

create
	make

feature -- Tests

	test_run
			--
		local
			file: ZSTRING
		do
			-- Jan 2020
			file := "linguistic-analysis.smil"
			do_file_test (file, agent new_smil_presentation, 2549506488)
			do_file_test (file, agent new_serializeable, 2549506488)

			file := "download-page.xhtml"
			do_file_test (file, agent new_web_form, 4143110532)
			do_file_test (file, agent new_serializeable, 4143110532)

			file := "request-matrix-sum.xml"
			do_file_test (file, agent new_matrix, 3557220573)
			do_file_test (file, agent new_serializeable, 3557220573)

			file := "request-matrix-average.xml"
			do_file_test (file, agent new_matrix, 1829577793)
			do_file_test (file, agent new_serializeable, 1829577793)
		end

feature {NONE} -- Implementation

	do_file_test (
		file_name: ZSTRING; new_object: FUNCTION [EL_FILE_PATH, EL_BUILDABLE_FROM_NODE_SCAN]; checksum: NATURAL
	)
		local
			file_path: EL_FILE_PATH
		do
			file_path := Createable_dir + file_name
			Test.do_file_test (file_path, agent build_and_serialize_file (?, new_object), checksum)
		end

	build_and_serialize_file (file_path: EL_FILE_PATH; new_object: FUNCTION [EL_FILE_PATH, EL_BUILDABLE_FROM_NODE_SCAN])
			--
		local
			object: EL_BUILDABLE_FROM_NODE_SCAN
		do
			log.enter_with_args ("build_and_serialize_file", [file_path])
			object := new_object (file_path)
			if attached {EVOLICITY_SERIALIZEABLE_AS_XML} object as serializeable then
				lio.put_path_field ("Saving", file_path)
				lio.put_new_line
				serializeable.save_as_xml (file_path)
			end
			log.exit
		end

feature {NONE} -- Factory

	new_matrix (file_in_path: EL_FILE_PATH): MATRIX_CALCULATOR
			--
		do
			create Result.make_from_file (file_in_path)
		end

	new_smil_presentation (file_in_path: EL_FILE_PATH): SMIL_PRESENTATION
			--
		do
			create Result.make_from_file (file_in_path)
		end

	new_web_form (file_in_path: EL_FILE_PATH): WEB_FORM
			--
		do
			create Result.make_from_file (file_in_path)
		end

	new_serializeable (file_in_path: EL_FILE_PATH): EL_BUILDABLE_FROM_NODE_SCAN
		-- detect type from processing instruction
		do
			Smart_builder.build_from_file (file_in_path)
			if Smart_builder.has_item then
				Result := Smart_builder.item
			end
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

feature {NONE} -- Constants

	Createable_dir: EL_DIR_PATH
		once
			Result := "XML/creatable"
		end

	Description: STRING
		once
			Result := "Auto test conversion of SMIL and XHTML documents to Eiffel and serialization back to XML"
		end

	Option_name: STRING
			--
		once
			Result := "object_builder"
		end

	Smart_builder: EL_SMART_BUILDABLE_FROM_NODE_SCAN
		once
			create {EL_SMART_XML_TO_EIFFEL_OBJECT_BUILDER} Result.make
		end

end
