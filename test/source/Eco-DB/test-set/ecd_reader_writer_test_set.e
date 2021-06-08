note
	description: "Test classes for Eiffel Chain Orientated database"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-08 13:53:40 GMT (Tuesday 8th June 2021)"
	revision: "5"

class
	ECD_READER_WRITER_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

	EL_SHARED_CURRENCY_ENUM

	EL_MODULE_BASE_64

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
			across << {STRING_32} "Xiǎo Chù 小畜", {STRING_32} "Trademark (™)" >> as str loop
				write_and_read (new_test_storable (str.item), Storable_reader_writer)
			end
			write_and_read (Ireland, Country_reader_writer)
		end

feature {NONE} -- Implementation

	new_test_storable (str: STRING_32): TEST_STORABLE
		do
			create Result.make_default
			Result.set_string_values  (str)
		end

	write_and_read (object: EL_REFLECTIVELY_SETTABLE_STORABLE; reader_writer: ECD_READER_WRITER [EL_STORABLE])
		note
			testing: "covers/{EL_MEMORY_READER_WRITER}.read_string", "covers/{EL_MEMORY_READER_WRITER}.write_string"
		local
			restored_object: EL_STORABLE
			zstr: ZSTRING
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
			if attached {TEST_STORABLE} object as l_object
				and then attached {TEST_STORABLE} restored_object as l_restored_object
			then
				create zstr.make_from_utf_8 (l_restored_object.string_utf_8)
				assert ("same as original", l_object.string ~ zstr)
				assert ("same as original", l_object.string_32 ~ zstr.to_string_32)
			end
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
			Result.set_continent ("Europe")
			Result.set_currency (Currency_enum.EUR)
			Result.set_date_founded (create {DATE}.make (1937, 12, 29))
			Result.set_literacy_rate (91.7)
			Result.set_population (4_845_000)
			Result.set_photo_jpeg (Base_64.decoded_special (Photo_data))
			Result.set_name ("Ireland")
			Result.set_temperature_range ([5, 17, "degrees"])
		end

	Photo_data: STRING
		once
			Result := "VyDHQ26RoAdUlNMQiWOKp22iUZEbS/VqWgX6rafZUGg="
		end

	Storable_reader_writer: ECD_READER_WRITER [TEST_STORABLE]
		once
			create Result.make
		end

end