note
	description: "Summary description for {STORABLE_TEST_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-30 14:15:30 GMT (Wednesday 30th December 2015)"
	revision: "5"

class
	STORABLE_TEST_SET

inherit
	EQA_TEST_SET

feature -- Basic operations

	test_storable
		note
			testing: "covers/{EL_MEMORY_READER_WRITER}.read_string",
						"covers/{EL_MEMORY_READER_WRITER}.write_string"
		local
			object_1, object_2: TEST_STORABLE
			reader_writer: EL_FILE_READER_WRITER [TEST_STORABLE]
			file: RAW_FILE
		do
			create object_1.make_default
			object_1.set_values  ({STRING_32} "Trademark ™")
			create reader_writer.make

			create file.make_open_write (File_path)
			reader_writer.write (object_1, file)
			file.close

			create file.make_open_read (File_path)
			object_2 := reader_writer.read_item (file)
			file.close

			assert ("read OK", object_1 ~ object_2)

			file.delete
		end

feature {NONE} -- Constants

	File_path: EL_FILE_PATH
		once
			Result := "stored.dat"
		end
end
