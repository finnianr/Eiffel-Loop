note
	description: "Storable test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "7"

class
	STORABLE_TEST_SET

inherit
	EQA_TEST_SET

	EL_MODULE_LIO
		undefine
			default_create
		end

feature -- Basic operations

	test_storable
		note
			testing: "covers/{EL_MEMORY_READER_WRITER}.read_string", "covers/{EL_MEMORY_READER_WRITER}.write_string"
		local
			object_1, object_2: TEST_STORABLE
			reader_writer: EL_FILE_READER_WRITER [TEST_STORABLE]
			file: RAW_FILE
		do
			create object_1.make_default
			object_1.print_fields (lio)
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

	test_uuid
		do
		end

feature {NONE} -- Constants

	File_path: EL_FILE_PATH
		once
			Result := "workarea/stored.dat"
		end
end
