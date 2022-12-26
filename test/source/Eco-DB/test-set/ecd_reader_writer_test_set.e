note
	description: "Test classes for Eiffel Chain Orientated database"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-26 14:44:35 GMT (Monday 26th December 2022)"
	revision: "16"

class
	ECD_READER_WRITER_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		undefine
			new_lio
		end

	COUNTRY_TEST_DATA

	EL_CRC_32_TEST_ROUTINES

	EL_SHARED_CURRENCY_ENUM

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("collection_read_write", agent test_collection_read_write)
			eval.call ("print_fields", agent test_print_fields)
			eval.call ("pyxis_export", agent test_pyxis_export)
			eval.call ("read_write", agent test_read_write)
			eval.call ("write_meta_data", agent test_write_meta_data)
		end

feature -- Tests

	test_collection_read_write
		-- ECD_READER_WRITER_TEST_SET.test_collection_read_write
		note
			testing: "covers/{EL_MEMORY_READER_WRITER}.read_string",
						"covers/{EL_MEMORY_READER_WRITER}.write_string",
						"covers/{EL_REFLECTED_COLLECTION}.write"
		do
			if attached new_country as country then
				country.print_fields (lio)

				check_values (country)
				if attached {COUNTRY} restored_object (country, Country_reader_writer) as restored then
					check_values (restored)
				else
					assert ("country restored", False)
				end
			end
		end

	test_print_fields
		do
			if attached new_country as country then
				do_test ("print_fields", 4263234204, agent country.print_fields (lio), [])
			end
		end

	test_pyxis_export
		note
			testing: "covers/{ECD_REFLECTIVE_RECOVERABLE_CHAIN}.export_pyxis"
		local
			data_table: COUNTRY_DATA_TABLE; data_path, pyxis_path: FILE_PATH
			export_digest: STRING
		do
			data_path := Work_area_dir + "country.dat"
			create data_table.make_from_file (data_path)
			data_table.extend (new_country)

			pyxis_path := data_path.with_new_extension ("pyx")
			data_table.export_pyxis (pyxis_path, Latin_1)

			export_digest := "0C8A6F4B61D6E67C5EFBD853B006CC45"
			assert_same_digest_hexadecimal (pyxis_path, export_digest)

			data_table.import_pyxis (pyxis_path)

			data_table.export_pyxis (pyxis_path, Latin_1)
			assert_same_digest_hexadecimal (pyxis_path, export_digest)

			data_table.close
		end

	test_read_write
		note
			testing: "covers/{EL_MEMORY_READER_WRITER}.read_string",
					"covers/{EL_MEMORY_READER_WRITER}.write_string"
		local
			t: EL_TIME_ROUTINES
		do
			across << {STRING_32} "Xiǎo Chù 小畜", {STRING_32} "Trademark (™)" >> as str loop
				if attached new_test_storable (str.item) as storable then
					storable.print_fields (lio)
					lio.put_new_line

					if attached {TEST_STORABLE} restored_object (storable, Storable_reader_writer) as restored then
						assert ("same string", storable.string ~ restored.string)
						assert ("same string", storable.string_32 ~ restored.string_32)
						assert ("same uuid", storable.uuid ~ restored.uuid)
						assert ("same time", t.same_time (storable.time, restored.time))
						assert ("same integer_list", storable.integer_list ~ restored.integer_list)
					else
						assert ("restored OK", False)
					end
				end
			end
		end

	test_write_meta_data
		note
			testing: "covers/{EL_REFLECTIVELY_SETTABLE_STORABLE}.write_meta_data"
		local
			meta_data: EL_PLAIN_TEXT_FILE
		do
			create meta_data.make_open_write (Work_area_dir + "country.e")
			meta_data.set_encoding (Latin_1)
			if attached new_country as country then
				country.write_meta_data (meta_data, 0)
				meta_data.close
			end
			assert_same_digest_hexadecimal (meta_data.path, "8816F18DF6ACAD66843B3F30A22A8E65")
		end

feature {NONE} -- Implementation

	new_test_storable (str: STRING_32): TEST_STORABLE
		local
			byte_array: EL_BYTE_ARRAY; zstr: ZSTRING; uuid: EL_UUID
			time: EL_TIME
		do
			zstr := str
			create byte_array.make_from_string (zstr.to_utf_8 (False))
			uuid := byte_array.to_uuid
			create time.make_from_string ("3:08:01.947 PM")

			create Result.make_default
			Result.set_string_values  (str)
			Result.uuid.copy (uuid)
			Result.time.copy (time)
			across str as character until Result.integer_list.count = 4 loop
				Result.integer_list.extend (character.item.code)
			end
		end

	restored_object (object: EL_REFLECTIVELY_SETTABLE_STORABLE; reader_writer: ECD_READER_WRITER [EL_STORABLE]): EL_STORABLE
		note
			testing: "covers/{EL_MEMORY_READER_WRITER}.read_string",
					"covers/{EL_MEMORY_READER_WRITER}.write_string"
		do
			File_path.set_base ("stored.dat")
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

	Country_reader_writer: ECD_READER_WRITER [COUNTRY]
		once
			create Result.make
		end

	File_path: FILE_PATH
		once
			Result := Work_area_dir + "data.x"
		end

	Storable_reader_writer: ECD_READER_WRITER [TEST_STORABLE]
		once
			create Result.make
		end

end