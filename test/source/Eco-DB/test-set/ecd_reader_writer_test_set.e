note
	description: "Test classes for Eiffel Chain Orientated database"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-08 17:53:18 GMT (Thursday 8th December 2022)"
	revision: "10"

class
	ECD_READER_WRITER_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

	STORABLE_COUNTRY_TEST_DATA

	EL_SHARED_CURRENCY_ENUM

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("read_write", agent test_read_write)
		end

feature -- Tests

	test_read_write
		note
			testing: "covers/{EL_MEMORY_READER_WRITER}.read_string",
					"covers/{EL_MEMORY_READER_WRITER}.write_string"
		local
			country: STORABLE_COUNTRY
		do
			across << {STRING_32} "Xiǎo Chù 小畜", {STRING_32} "Trademark (™)" >> as str loop
				if attached new_test_storable (str.item) as storable then
					if attached {TEST_STORABLE} restored_object (storable, Storable_reader_writer) as restored then
						assert ("same string", storable.string ~ restored.string)
						assert ("same string", storable.string_utf_8 ~ restored.string_utf_8)
						assert ("same string", storable.string_32 ~ restored.string_32)
					else
						assert ("restored OK", False)
					end
				end
			end

			create country.make (Value_table)
			check_values (country)
			if attached {STORABLE_COUNTRY} restored_object (country, Country_reader_writer) as restored then
				check_values (restored)
			else
				assert ("country restored", False)
			end
		end

feature {NONE} -- Implementation

	new_test_storable (str: STRING_32): TEST_STORABLE
		do
			create Result.make_default
			Result.set_string_values  (str)
		end

	restored_object (object: EL_REFLECTIVELY_SETTABLE_STORABLE; reader_writer: ECD_READER_WRITER [EL_STORABLE]): EL_STORABLE
		note
			testing: "covers/{EL_MEMORY_READER_WRITER}.read_string",
					"covers/{EL_MEMORY_READER_WRITER}.write_string"
		do
			File_path.set_base ("stored.dat")

			object.print_fields (lio)

			if attached open_raw (File_path, Write) as l_file then
				reader_writer.write (object, l_file)
				l_file.close
			end

			if attached open_raw (File_path, Read) as l_file then
				Result := reader_writer.read_item (l_file)
				l_file.close
			end
		end

feature {NONE} -- Constants

	File_path: FILE_PATH
		once
			Result := Work_area_dir + "data.x"
		end

	Country_reader_writer: ECD_READER_WRITER [STORABLE_COUNTRY]
		once
			create Result.make
		end

	Storable_reader_writer: ECD_READER_WRITER [TEST_STORABLE]
		once
			create Result.make
		end

end