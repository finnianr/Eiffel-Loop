note
	description: "Test classes for Eiffel Chain Orientated database"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-20 9:49:49 GMT (Saturday 20th March 2021)"
	revision: "3"

class
	ECD_READER_WRITER_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("read_write", agent test_read_write)
		end

feature -- Tests

	test_read_write
		note
			testing: "covers/{EL_MEMORY_READER_WRITER}.read_string", "covers/{EL_MEMORY_READER_WRITER}.write_string"
		do
			write_and_read (Trademark_symbol, Storable_reader_writer)
			write_and_read (Ireland, Country_reader_writer)
		end

feature {NONE} -- Implementation

	write_and_read (object: EL_REFLECTIVELY_SETTABLE_STORABLE; reader_writer: ECD_READER_WRITER [EL_STORABLE])
		note
			testing: "covers/{EL_MEMORY_READER_WRITER}.read_string", "covers/{EL_MEMORY_READER_WRITER}.write_string"
		local
			restored_object: EL_STORABLE
		do
			File_path.set_base ("stored.dat")

			object.print_fields (lio)

			if attached open_raw (File_path, Write) as file then
				reader_writer.write (object, file)
				file.close
			end

			if attached open_raw (File_path, Read) as file then
				restored_object := reader_writer.read_item (file)
				file.close
			end

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