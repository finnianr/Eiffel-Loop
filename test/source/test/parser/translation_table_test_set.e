note
	description: "Summary description for {TRANSLATION_TABLE_TEST_SET}."

	

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 20:21:04 GMT (Sunday 21st May 2017)"
	revision: "2"

class
	TRANSLATION_TABLE_TEST_SET

inherit
	EIFFEL_LOOP_TEST_SET

feature -- Tests

	test_reading_from_file
		do
			log.enter ("test_reading_from_file")
			test_reading (agent new_table_from_file)
			log.exit
		end

	test_reading_from_source
		do
			log.enter ("test_reading_from_source")
			test_reading (agent new_table_from_source)
			log.exit
		end

feature {NONE} -- Implementation

	test_reading (new_table: FUNCTION [STRING, EL_FILE_PATH, EL_TRANSLATION_TABLE])
		local
			pyxis_file_path: EL_FILE_PATH; table: EL_TRANSLATION_TABLE
			crc_32: EL_CYCLIC_REDUNDANCY_CHECK_32
		do
			create crc_32
			across Pyxis_translation_checksums as checksum loop
				crc_32.reset
				pyxis_file_path := Test_data_dir.joined_file_steps (<< "pyxis", "localization", checksum.key + ".xml.pyx" >>)
				log.put_path_field ("Localization", pyxis_file_path)
				log.put_new_line
				across << "en", "de" >> as language loop
					table := new_table (language.item, pyxis_file_path)
					across table as translation loop
						crc_32.add_string (translation.key)
						crc_32.add_string (translation.item)
						log.put_string_field_to_max_length (translation.key, translation.item, 200)
						log.put_new_line
					end
				end
				log.put_labeled_string ("checksum", crc_32.checksum.out)
				log.put_new_line
				assert ("checksum OK", crc_32.checksum = checksum.item)
			end
		end

	new_table_from_file (language: STRING; file_path: EL_FILE_PATH): EL_TRANSLATION_TABLE
		do
			create Result.make_from_pyxis (language, file_path)
		end

	new_table_from_source (language: STRING; file_path: EL_FILE_PATH): EL_TRANSLATION_TABLE
		do
			create Result.make_from_pyxis_source (language, File_system.plain_text (file_path))
		end

feature {NONE} -- Constants

	Pyxis_translation_checksums: HASH_TABLE [NATURAL, STRING]
		do
			create Result.make_equal (3)
			Result ["credits"] := 448943560
			Result ["phrases"] := 3915780596
			Result ["words"] := 3350244775
		end

end