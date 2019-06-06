note
	description: "Test for class [$source EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-06 19:26:16 GMT (Thursday 6th June 2019)"
	revision: "1"

class
	REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		rename
			new_file_tree as new_empty_file_tree
		redefine
			on_prepare
		end

	EL_SHARED_DEFAULT_VALUE_TABLE
		undefine
			default_create
		end

feature -- Tests

	test_store_and_build
		local
			file_path: EL_FILE_PATH
			config: TEST_CONFIGURATION
		do
			file_path := Work_area_dir + "data.txt"
			create config.make_from_file ("data/config.xml")
--			assert ("same crc", Crc_32.utf_8_file_lines (file_path) = Crc_32.lines (Strings))
		end

feature {NONE} -- Implementation

	on_prepare
		do
			Precursor
			Default_value_table.extend_from_array (<< create {TEST_VALUES}.make >>)
		end

end
