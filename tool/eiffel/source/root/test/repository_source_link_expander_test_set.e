note
	description: "Repository source link expander test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-07 12:17:32 GMT (Wednesday 7th August 2019)"
	revision: "4"

class
	REPOSITORY_SOURCE_LINK_EXPANDER_TEST_SET

inherit
	REPOSITORY_PUBLISHER_TEST_SET
		redefine
			new_publisher, on_prepare, generated_files
		end

	SHARED_HTML_CLASS_SOURCE_TABLE

feature -- Tests

	test_link_expander
		local
			n: INTEGER; publisher: like new_publisher
		do
			log.enter ("test_publisher")
			publisher := new_publisher
			publisher.execute
			check_expanded_contents (publisher)
			n := User_input.integer ("Return to finish")
			log.exit
		end

feature {NONE} -- Events

	on_prepare
		local
			file: EL_PLAIN_TEXT_FILE
		do
			Precursor
			create file.make_open_write (File_path)
			file.put_string_8 ("[
				Class [$source EL_REFLECTIVELY_SETTABLE] inherits from class [$source EL_REFLECTIVE]
			]")
			file.close
		end

feature {NONE} -- Implementation

	check_expanded_contents (publisher: like new_publisher)
		local
			web_url: EL_DIR_URI_PATH; class_url: EL_FILE_URI_PATH
			blog_text: ZSTRING
		do
			web_url := publisher.web_address + "/"
			blog_text := OS.File_system.plain_text (publisher.expanded_file_path)
			across << "EL_REFLECTIVE", "EL_REFLECTIVELY_SETTABLE" >> as name loop
				class_url := web_url + Class_source_table.item (name.item)
				assert ("has uri path", blog_text.has_substring (class_url.to_string))
			end
		end

	generated_files: like OS.file_list
		do
			Result := OS.file_list (Work_area_dir, "*.txt")
		end

	new_publisher: REPOSITORY_TEST_SOURCE_LINK_EXPANDER
		do
			create Result.make (File_path, Work_area_dir + "doc-config/config-1.pyx", "1.4.0", 0)
		end

feature {NONE} -- Constants

	File_path: EL_FILE_PATH
		once
			Result := Work_area_dir + "blog.txt"
		end

end
