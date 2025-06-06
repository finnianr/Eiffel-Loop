﻿note
	description: "Test classes for Eiffel Chain Orientated database"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 14:08:27 GMT (Monday 28th April 2025)"
	revision: "35"

class
	ECD_READER_WRITER_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

	COUNTRY_TEST_DATA

	EL_SHARED_CURRENCY_ENUM

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["collection_read_write", agent test_collection_read_write],
				["print_fields",			  agent test_print_fields],
				["pyxis_export",			  agent test_pyxis_export],
				["read_write",				  agent test_read_write],
				["storable_arrayed_list", agent test_storable_arrayed_list],
				["storable_tuple_list",	  agent test_storable_tuple_list],
				["write_meta_data",		  agent test_write_meta_data]
			>>)
		end

feature -- Tests

	test_collection_read_write
		-- ECD_READER_WRITER_TEST_SET.test_collection_read_write
		note
			testing: "[
				covers/{EL_MEMORY_READER_WRITER}.read_string,
				covers/{EL_MEMORY_READER_WRITER}.write_string,
				covers/{EL_REFLECTED_COLLECTION}.write
			]"
		do
			if attached new_country (Ireland) as country then
				country.print_fields (lio)

				check_values_ireland (country)
				if attached {COUNTRY} restored_object (country, Country_reader_writer) as restored then
					check_values_ireland (restored)
				else
					failed ("country restored")
				end
			end
		end

	test_print_fields
		do
			if attached new_country (Ireland) as country then
				do_test ("print_fields", 932900685, agent country.print_fields (lio), [])
			end
		end

	test_pyxis_export
		-- ECD_READER_WRITER_TEST_SET.pyxis_export
		note
			testing: "covers/{ECD_REFLECTIVE_RECOVERABLE_CHAIN}.export_pyxis"
		local
			data_table: COUNTRY_DATA_TABLE; data_path, pyxis_path: FILE_PATH
		do
			data_path := Work_area_dir + "country.dat"
			create data_table.make_from_file (data_path)
			data_table.extend (new_country (Ireland))
			data_table.extend (new_country (India))

			pyxis_path := data_path.with_new_extension ("pyx")
			data_table.export_pyxis (pyxis_path, Latin_1)

			if attached ("xdvebKdoIWHUoV/MK558Jg==") as export_digest then
				assert_same_digest (Plain_text, pyxis_path, export_digest)

				data_table.import_pyxis (pyxis_path)

				data_table.export_pyxis (pyxis_path, Latin_1)
				assert_same_digest (Plain_text, pyxis_path, export_digest)
			end

			data_table.close
		end

	test_read_write
		note
			testing: "[
				covers/{EL_MEMORY_READER_WRITER}.read_string,
				covers/{EL_MEMORY_READER_WRITER}.write_string
			]"
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
						failed ("restored OK")
					end
				end
			end
		end

	test_storable_arrayed_list
		-- ECD_READER_WRITER_TEST_SET.test_storable_arrayed_list
		local
			country_list: ECD_STORABLE_ARRAYED_LIST [COUNTRY]
			country: COUNTRY
		do
			File_path.set_base ("country.dat")
			create country_list.make (1)
			country := new_country (Ireland)
			country_list.extend (country)
			across 1 |..| 2 as n loop
				if n.is_first then
					country_list.store_as (File_path)
				else
					country_list.store
				end
				if File_path.exists then
					create country_list.make_from_file (File_path)

					assert ("one item", country_list.count = 1)
					assert ("same item", country_list.first ~ country)
				else
					failed ("stored")
				end
			end
		end

	test_storable_tuple_list
		-- ECD_READER_WRITER_TEST_SET.test_storable_tuple_list
		note
			testing: "[
				covers/{ECD_ARRAYED_TUPLE_LIST}.make_from_file,
				covers/{ECD_ARRAYED_TUPLE_LIST}.store_as
			]"
		local
			tuple_list: ECD_ARRAYED_TABLE_PAIR_LIST [INTEGER, STRING]
			table: EL_HASH_TABLE [INTEGER, STRING]; numbers_path: FILE_PATH
		do
			table := << ["One", 1], ["Two", 2], ["Three", 3] >>
			create tuple_list.make_from_table (table)
			numbers_path := Work_area_dir + "numbers.dat"
			tuple_list.store_as (numbers_path)

			create tuple_list.make_from_file (numbers_path)
			assert ("same count", tuple_list.count = table.count)
			across tuple_list as list loop
				assert ("key present", table.has_key (list.item.key))
				assert ("same value", table.found_item = list.item.value)
			end
		end

	test_write_meta_data
		-- ECD_READER_WRITER_TEST_SET.test_write_meta_data
		note
			testing: "covers/{EL_REFLECTIVELY_SETTABLE_STORABLE}.write_meta_data"
		local
			meta_data: EL_PLAIN_TEXT_FILE
		do
			create meta_data.make_open_write (Work_area_dir + "country.e")
			meta_data.set_encoding (Latin_1)
			if attached new_country (Ireland) as country then
				country.write_meta_data (meta_data, 0)
				meta_data.close
			end
			assert_same_digest (Plain_text, meta_data.path, "iBbxjfasrWaEOz8woiqOZQ==")
		end

feature {NONE} -- Implementation

	new_test_storable (str: STRING_32): TEST_STORABLE
		local
			byte_array: EL_BYTE_ARRAY; uuid: EL_UUID; time: EL_TIME
		do
			create byte_array.make_from_string_32 (str)
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
			testing: "[
				covers/{EL_MEMORY_READER_WRITER}.read_string,
				covers/{EL_MEMORY_READER_WRITER}.write_string
			]"
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