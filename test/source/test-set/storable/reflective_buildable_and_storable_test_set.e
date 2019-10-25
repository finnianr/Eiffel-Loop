note
	description: "Test classes that use reflective persistence"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-05 13:46:25 GMT (Saturday   5th   October   2019)"
	revision: "8"

class
	REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_SET

inherit
	EL_GENERATED_FILE_DATA_TEST_SET
		rename
			new_file_tree as new_empty_file_tree
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

	test_read_write
		note
			testing: "covers/{EL_MEMORY_READER_WRITER}.read_string", "covers/{EL_MEMORY_READER_WRITER}.write_string"
		do
			write_and_read (Trademark_symbol, Storable_reader_writer)
			write_and_read (Ireland, Country_reader_writer)
		end

feature {NONE} -- Implementation

	write_and_read (
		object: EL_REFLECTIVELY_SETTABLE_STORABLE
		reader_writer: ECD_READER_WRITER [EL_STORABLE]
	)
		note
			testing: "covers/{EL_MEMORY_READER_WRITER}.read_string", "covers/{EL_MEMORY_READER_WRITER}.write_string"
		local
			file: RAW_FILE; restored_object: EL_STORABLE
		do
			File_path.set_base ("stored.dat")

			object.print_fields (lio)

			create file.make_open_write (File_path)
			reader_writer.write (object, file)
			file.close

			create file.make_open_read (File_path)
			restored_object := reader_writer.read_item (file)
			file.close

			assert ("restored OK", object ~ restored_object)
		end

feature {NONE} -- Constants

	File_path: EL_FILE_PATH
		once
			Result := Work_area_dir + "data.x"
		end

	Country_reader_writer: ECD_READER_WRITER [STORABLE_COUNTRY]
		once
			create Result.make
		end

	Ireland: STORABLE_COUNTRY
		once
			create Result.make_default
			Result.set_code ("IE")
			Result.set_literacy_rate (91.7)
			Result.set_population (4_845_000)
			Result.set_name ("Ireland")
			Result.set_temperature_range ([5, 17, "degrees"])
		end

	Storable_reader_writer: ECD_READER_WRITER [TEST_STORABLE]
		once
			create Result.make
		end

	Trademark_symbol: TEST_STORABLE
		once
			create Result.make_default
			Result.set_string_values  ({STRING_32} "Trademark symbol (™)")
		end

end
