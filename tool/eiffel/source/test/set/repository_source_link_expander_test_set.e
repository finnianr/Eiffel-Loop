note
	description: "Repository source link expander test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 12:09:57 GMT (Friday 10th March 2023)"
	revision: "16"

class
	REPOSITORY_SOURCE_LINK_EXPANDER_TEST_SET

inherit
	REPOSITORY_PUBLISHER_TEST_SET
		redefine
			make, new_publisher, on_prepare, generated_files
		end

	SHARED_CLASS_PATH_TABLE

	SHARED_ISE_CLASS_TABLE

	EL_MODULE_EXECUTABLE; EL_MODULE_FILE

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["link_expander", agent test_link_expander]
			>>)
		end

feature -- Tests

	test_link_expander
		local
			publisher: like new_publisher
		do
			publisher := new_publisher
			publisher.execute
			check_expanded_contents (publisher)
			if Executable.Is_work_bench
				and then attached User_input.line ("Return to finish") as line
			then
			end
		end

feature {NONE} -- Events

	on_prepare
		do
			Precursor
			if attached open (File_path, Write) as f then
				f.put_string (Inherits_template #$ [Type_descendant.name, Type_base.name])
				f.close
			end
		end

feature {NONE} -- Implementation

	check_expanded_contents (publisher: like new_publisher)
		local
			web_url: EL_DIR_URI_PATH; class_url: EL_FILE_URI_PATH
			blog_text, name: ZSTRING
		do
			web_url := publisher.web_address + "/"
			blog_text := File.plain_text (publisher.expanded_file_path)
			across << Type_base, Type_descendant >> as type loop
				name := type.item.name
				if Class_path_table.has_class (name) then
					class_url := web_url + Class_path_table.found_item

				elseif ISE_class_table.has_class (name) then
					class_url := ISE_class_table.found_item
				else
					class_url := web_url + ""
				end
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

	File_path: FILE_PATH
		once
			Result := Work_area_dir + "blog.txt"
		end

	Type_base: TYPE [ANY]
		once
			Result := {EL_STORABLE}
		end

	Type_descendant: TYPE [ANY]
		once
			Result := {EL_STORABLE_IMPL}
		end

	Inherits_template: ZSTRING
		once
			Result := "Class ${%S} inherits from class ${%S}"
		end

end