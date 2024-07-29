note
	description: "Test class ${EL_PYXIS_TREE_TO_XML_COMPILER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-29 8:45:49 GMT (Monday 29th July 2024)"
	revision: "11"

class
	PYXIS_TREE_TO_XML_COMPILER_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

	SHARED_DEV_ENVIRON; EL_SHARED_KEY_LANGUAGE

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["compiler", agent test_compiler]
			>>)
		end

feature -- Tests

	test_compiler
		note
			testing: "[
				covers/{EL_MERGED_PYXIS_LINE_LIST}.make,
				covers/{EL_PYXIS_TREE_TO_XML_COMPILER}.execute,
				covers/{EL_PYXIS_ML_TRANSLATION_TABLE}.make_from_file,
				covers/{EL_XML_ML_TRANSLATION_TABLE}.make_from_xdoc
			]"
		local
			merged_xml_table: EL_XML_ML_TRANSLATION_TABLE; pyxis_table: EL_PYXIS_ML_TRANSLATION_TABLE
			compiler: EL_PYXIS_TREE_TO_XML_COMPILER; destination_path: FILE_PATH
			item_count, time_stamp: INTEGER; key: ZSTRING
		do
			destination_path := work_area_data_dir.parent + "localization.xml"
			create compiler.make ("", work_area_data_dir, destination_path)
			compiler.execute
			create merged_xml_table.make_from_file (destination_path)

			across OS.file_list (work_area_data_dir, "*.pyx") as path loop
				create pyxis_table.make_from_file (path.item)
				across pyxis_table as table loop
					key := table.key
					item_count := item_count + 1
					assert ("merged XML table has key", merged_xml_table.has (key))
				end
			end
			assert ("same item count", item_count = merged_xml_table.count)

			time_stamp := destination_path.modification_time
			compiler.execute
			assert ("file not changed", time_stamp = destination_path.modification_time)
		end

feature {NONE} -- Implementation

	source_dir: DIR_PATH
		do
			Result := Dev_environ.EL_test_data_dir #+ "pyxis/localization"
		end

end