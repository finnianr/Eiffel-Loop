note
	description: "Test classes that use reflective persistence"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 17:29:39 GMT (Friday 10th March 2023)"
	revision: "18"

class
	REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["reflective_buildable_and_storable_as_xml",	agent test_reflective_buildable_and_storable_as_xml]
			>>)
		end

feature -- Tests

	test_reflective_buildable_and_storable_as_xml
		local
			config, config_2: TEST_CONFIGURATION
			l_values, new_values: TEST_VALUES; i: INTEGER
		do
			File_path.set_base ("config.xml")
			create l_values.make (1.1, 1)
			create config.make ("/home/finnian/Graphics/icon.png", "'&' means %"and%"", l_values)

			assert ("8 fields", config.field_table.count = 8)

			config.substring_interval.start_index := 5
			config.substring_interval.end_index := 10

			from i := 1 until i > 3 loop
				new_values := l_values.twin
				new_values.set_integer (i)
				new_values.set_double (l_values.double * i)
				config.values_list.extend (new_values)
				i := i + 1
			end

			from i := 1 until i > 4 loop
				if i = 1 then
					config.integer_list.extend (1)
				else
					config.integer_list.extend (config.integer_list.last * 2)
				end
				i := i + 1
			end
			config.colors.extend ("Red")
			config.colors.extend ("Green")
			config.colors.extend ("Blue")

			config.set_file_path (File_path)
			config.store
			create config_2.make_from_file (File_path)
			assert ("same configurations", config ~ config_2)
		end

feature {NONE} -- Constants

	File_path: FILE_PATH
		once
			Result := Work_area_dir + "data.x"
		end

end