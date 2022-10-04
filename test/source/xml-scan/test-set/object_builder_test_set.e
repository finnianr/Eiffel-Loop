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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-04 9:21:41 GMT (Tuesday 4th October 2022)"
	revision: "17"

class
	OBJECT_BUILDER_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		undefine
			new_lio
		redefine
			on_prepare
		end

	EL_MODULE_TUPLE

	EL_CRC_32_TEST_ROUTINES

	SHARED_DEV_ENVIRON

feature {NONE} -- Initialization

	on_prepare
		do
			Precursor {EL_FILE_DATA_TEST_SET}
			factory_types := <<
				create {BUILDER_FACTORY}.make, create {BINARY_BUILDER_FACTORY}.make (Work_area_dir)
			>>
		end

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("buildable_from_node_scan",			agent test_buildable_from_node_scan)
			eval.call ("smart_buildable_from_node_scan",	agent test_smart_buildable_from_node_scan)
			eval.call ("recursive_object_build",			agent test_recursive_object_build)
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

	test_smart_buildable_from_node_scan
		-- object type determined by `create' XML processing instruction in document
		-- 10 Feb 2020
		do
			across factory_types as type loop
				smart_build (type.item)
			end
		end

	test_recursive_object_build
		-- 10 Feb 2020
		do
			do_test ("create_bioinformatic_commands", 4104321945, agent create_bioinformatic_commands, [])
		end

feature {NONE} -- Implementation

	build (type: BUILDER_FACTORY)
		local
			l_name: STRING
		do
			log.enter_with_args ("build", [type])
			l_name := Routine_name
			do_test (l_name, 561488628,
				agent build_and_serialize_file, [Name.smil_presentation, agent type.new_smil_presentation]
			)
			do_test (l_name, 3086032535, agent build_and_serialize_file, [Name.web_form, agent type.new_web_form] )
			do_test (l_name, 1024683824, agent build_and_serialize_file, [Name.matrix_average, agent type.new_matrix])
			do_test (l_name, 2770913439, agent build_and_serialize_file, [Name.matrix_sum, agent type.new_matrix])
			log.exit
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
				log.put_labeled_string ("Digest saved " + file_path.base, raw_file_digest (file_path).to_base_64_string)
				log.put_new_line
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
			log.enter_with_args ("smart_build", [type])
			l_name := Routine_name
			do_test (l_name, 944788983, agent build_and_serialize_file, [Name.smil_presentation, agent type.new_serializeable])
			do_test (l_name, 540764938, agent build_and_serialize_file, [Name.web_form, agent type.new_serializeable])
			do_test (l_name, 4129507502, agent build_and_serialize_file, [Name.matrix_average, agent type.new_serializeable])
			do_test (l_name, 345614884, agent build_and_serialize_file, [Name.matrix_sum, agent type.new_serializeable])
			log.exit
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