note
	description: "Object builder test sub application"
	descendants: "[
			OBJECT_BUILDER_TEST_SUB_APPLICATION*
				[$source OBJECT_BUILDER_TEST_APP]
				[$source BINARY_ENCODED_XML_BUILDER_TEST_APP]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-10 11:33:01 GMT (Friday 10th January 2020)"
	revision: "1"

deferred class
	OBJECT_BUILDER_TEST_SUB_APPLICATION

inherit
	TEST_SUB_APPLICATION

feature {NONE} -- Implementation

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

	do_file_test (
		file_name: ZSTRING; new_object: FUNCTION [EL_FILE_PATH, EL_BUILDABLE_FROM_NODE_SCAN]; checksum: NATURAL
	)
		local
			file_path: EL_FILE_PATH
		do
			file_path := Createable_dir + file_name
			Test.do_file_test (file_path, agent build_and_serialize_file (?, new_object), checksum)
		end

feature {NONE} -- Constants

	Createable_dir: EL_DIR_PATH
		once
			Result := "XML/creatable"
		end

end
