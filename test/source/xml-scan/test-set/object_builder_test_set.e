note
	description: "[
		Test set for classes
		
		* [$source EL_BUILDABLE_FROM_NODE_SCAN]
		* [$source EL_PARSE_EVENT_GENERATOR]
		* [$source EL_BINARY_ENCODED_PARSE_EVENT_SOURCE]
		* [$source EL_EXPAT_XML_PARSER]
		* [$source EVOLICITY_SERIALIZEABLE_AS_XML]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-10 13:25:00 GMT (Monday 10th July 2023)"
	revision: "26"

class
	OBJECT_BUILDER_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		undefine
			new_lio
		redefine
			on_prepare
		end

	EL_CRC_32_TESTABLE

	EL_MODULE_TUPLE

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Initialization

	on_prepare
		do
			Precursor {EL_FILE_DATA_TEST_SET}
			factory_types := <<
				create {BUILDER_FACTORY}.make, create {BINARY_BUILDER_FACTORY}.make (Work_area_dir)
			>>
		end

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["buildable_from_node_scan",		  agent test_buildable_from_node_scan],
				["smart_buildable_from_node_scan", agent test_smart_buildable_from_node_scan],
				["recursive_object_build",			  agent test_recursive_object_build]
			>>)
		end

feature -- Tests

	test_buildable_from_node_scan
		-- 10 Feb 2020
		-- OBJECT_BUILDER_TEST_SET.test_buildable_from_node_scan
		do
			across factory_types as type loop
				build (type.item)
			end
		end

	test_recursive_object_build
		-- OBJECT_BUILDER_TEST_SET.test_recursive_object_build
		do
			do_test ("create_bioinformatic_commands", 2238350059, agent create_bioinformatic_commands, [])
		end

	test_smart_buildable_from_node_scan
		-- OBJECT_BUILDER_TEST_SET.test_smart_buildable_from_node_scan
		-- object type determined by `create' XML processing instruction in document
		-- 10 Feb 2020
		do
			across factory_types as type loop
				smart_build (type.item)
			end
		end

feature {NONE} -- Implementation

	build (type: BUILDER_FACTORY)
		local
			l_name: STRING
		do
			lio.enter_with_args ("build", [type])
			l_name := Routine_name
			do_test (l_name, os_checksum (4129697351, 1575710143),
				agent build_and_serialize_file, [Name.smil_presentation, agent type.new_smil_presentation]
			)
			do_test (l_name, os_checksum (3086032535, 3664224275),
				agent build_and_serialize_file, [Name.web_form, agent type.new_web_form]
			)
			do_test (l_name, 1024683824, agent build_and_serialize_file, [Name.matrix_average, agent type.new_matrix])
			do_test (l_name, 2770913439, agent build_and_serialize_file, [Name.matrix_sum, agent type.new_matrix])
			lio.exit
		end

	build_and_serialize_file (file_name: STRING; new_object: FUNCTION [FILE_PATH, EL_BUILDABLE_FROM_NODE_SCAN])
			--
		local
			object: EL_BUILDABLE_FROM_NODE_SCAN; file_path: FILE_PATH
		do
			file_path := Work_area_dir + file_name
			object := new_object (XML_dir.joined_file_tuple (["creatable", file_name]))
			if attached {EVOLICITY_SERIALIZEABLE_AS_XML} object as serializeable then
				serializeable.save_as_xml (file_path)
				lio.put_labeled_string ("Digest saved " + file_path.base, raw_file_digest (file_path).to_base_64_string)
				lio.put_new_line
			end
		end

	create_bioinformatic_commands
			--
		local
			commands: BIOINFORMATIC_COMMANDS
		do
			create commands.make_from_file (Dev_environ.El_test_data_dir + "vtd-xml/bioinfo.xml")
			commands.display
		end

	smart_build (type: BUILDER_FACTORY)
			-- 10 Feb 2020
		local
			l_name: STRING
		do
			lio.enter_with_args ("smart_build", [type])
			l_name := Routine_name
			do_test (l_name, os_checksum (3153713107, 271881259),
				agent build_and_serialize_file, [Name.smil_presentation, agent type.new_serializeable]
			)
			do_test (l_name, os_checksum (540764938, 1303238030),
				agent build_and_serialize_file, [Name.web_form, agent type.new_serializeable]
			)
			do_test (l_name, 4129507502, agent build_and_serialize_file, [Name.matrix_average, agent type.new_serializeable])
			do_test (l_name, 345614884, agent build_and_serialize_file, [Name.matrix_sum, agent type.new_serializeable])
			lio.exit
		end

feature {NONE} -- Internal attributes

	factory_types: ARRAY [BUILDER_FACTORY]

feature {NONE} -- Constants

	Name: TUPLE [web_form, smil_presentation, matrix_average, matrix_sum: STRING]
		once
			create Result
			Tuple.fill (Result,
				"download-page.xhtml, linguistic-analysis.smil, request-matrix-average.xml, request-matrix-sum.xml"
			)
		end

	Routine_name: STRING = "build_and_serialize_file"

	XML_dir: DIR_PATH
		once
			Result := Dev_environ.EL_test_data_dir #+ "XML"
		end

end