note
	description: "Test for class [$source EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-09 10:21:32 GMT (Sunday 9th June 2019)"
	revision: "4"

class
	REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		rename
			new_file_tree as new_empty_file_tree
		end

	EL_SHARED_DEFAULT_VALUE_TABLE
		undefine
			default_create
		end

feature -- Tests

	test_store_and_build
		local
			file_path: EL_FILE_PATH
			config, config_2: TEST_CONFIGURATION
			l_values, new_values: TEST_VALUES; i: INTEGER
		do
			file_path := Work_area_dir + "config.xml"
			create l_values.make (1.1, 1)
			create config.make ("/home/finnian/Graphics/icon.png", "'&' means %"and%"", l_values)
			from i := 1 until i > 3 loop
				new_values := l_values.twin
				new_values.set_integer (i)
				new_values.set_double (l_values.double * i)
				config.values_list.extend (new_values)
				i := i + 1
			end
			config.colors.extend ("Red")
			config.colors.extend ("Green")
			config.colors.extend ("Blue")

			config.set_file_path (file_path)
			config.store
			create config_2.make_from_file (file_path)
			assert ("same configurations", config ~ config_2)
		end

end
