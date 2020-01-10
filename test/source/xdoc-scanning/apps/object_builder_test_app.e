note
	description: "[
		Test conversion of SMIL and XHTML documents to Eiffel and serialization back to XML.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-10 11:32:31 GMT (Friday 10th January 2020)"
	revision: "14"

class
	OBJECT_BUILDER_TEST_APP

inherit
	OBJECT_BUILDER_TEST_SUB_APPLICATION
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
			if false then
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
		end

feature {NONE} -- Factory

	new_matrix (file_path: EL_FILE_PATH): MATRIX_CALCULATOR
			--
		do
			create Result.make_from_file (file_path)
		end

	new_smil_presentation (file_path: EL_FILE_PATH): SMIL_PRESENTATION
			--
		do
			create Result.make_from_file (file_path)
		end

	new_web_form (file_path: EL_FILE_PATH): WEB_FORM
			--
		do
			create Result.make_from_file (file_path)
		end

	new_serializeable (file_path: EL_FILE_PATH): EL_BUILDABLE_FROM_NODE_SCAN
		-- detect type from processing instruction
		do
			Smart_builder.build_from_file (file_path)
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
