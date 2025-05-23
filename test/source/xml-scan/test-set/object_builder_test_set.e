note
	description: "[
		Test set for classes
		
		* ${EL_BUILDABLE_FROM_NODE_SCAN}
		* ${EL_PARSE_EVENT_GENERATOR}
		* ${EL_BINARY_ENCODED_PARSE_EVENT_SOURCE}
		* ${EL_EXPAT_XML_PARSER}
		* ${EVC_SERIALIZEABLE_AS_XML}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 20:30:21 GMT (Sunday 4th May 2025)"
	revision: "33"

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

	SHARED_DATA_DIRECTORIES

create
	make

feature {NONE} -- Initialization

	on_prepare
		do
			Precursor
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
		note
			testing: "[
				covers/{EVC_EVALUATE_DIRECTIVE}.execute
			]"
		do
			across factory_types as type loop
				build (type.item)
			end
		end

	test_recursive_object_build
		-- OBJECT_BUILDER_TEST_SET.test_recursive_object_build
		do
			do_test ("create_bioinformatic_commands", 2795663237, agent create_bioinformatic_commands, [])
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
			do_test (l_name, os_checksum (2003533171, 282829992),
				agent build_and_serialize_file, [Name.smil_presentation, agent type.new_smil_presentation]
			)
			do_test (l_name, os_checksum (396053008, 3664224275),
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
			object := new_object (Data_dir.xml.joined_file_tuple (["creatable", file_name]))
			if attached {EVC_SERIALIZEABLE_AS_XML} object as serializeable then
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
			create commands.make_from_file (Data_dir.vtd_xml + "bioinfo.xml")
			commands.display
		end

	smart_build (type: BUILDER_FACTORY)
			-- 10 Feb 2020
		local
			l_name: STRING
		do
			lio.enter_with_args ("smart_build", [type])
			l_name := Routine_name
			do_test (l_name, os_checksum (1803675339, 204554000),
				agent build_and_serialize_file, [Name.smil_presentation, agent type.new_serializeable]
			)
			do_test (l_name, os_checksum (2152808333, 1303238030),
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

end