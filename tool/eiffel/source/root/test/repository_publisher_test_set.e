note
	description: "Repository publisher test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-07 12:54:47 GMT (Wednesday 7th August 2019)"
	revision: "20"

class
	REPOSITORY_PUBLISHER_TEST_SET

inherit
	EL_GENERATED_FILE_DATA_TEST_SET
		rename
			new_file_tree as new_empty_file_tree
		redefine
			on_prepare
		end

	EL_EIFFEL_LOOP_TEST_CONSTANTS

	EL_ZSTRING_CONSTANTS

	EL_MODULE_USER_INPUT

	EL_MODULE_EXECUTION_ENVIRONMENT

feature -- Tests

	test_publisher
		local
			publisher: like new_publisher; editor: FIND_AND_REPLACE_EDITOR
			line: ZSTRING
		do
			log.enter ("test_publisher")
			publisher := new_publisher
			publisher.execute
			check_html_exists (publisher)

			create editor.make ("ht_extend", "table_extend")
			editor.set_file_path (Hash_set_path)
			editor.edit
			line := User_input.line ("Enter to continue")
			publisher := new_publisher
			publisher.execute

			assert ("Three files uploaded", Modified_files.count = publisher.ftp_sync.ftp.uploaded_list.count
				and then across publisher.ftp_sync.ftp.uploaded_list as path all
					Modified_files.has (path.item.base)
				end
			)
			log.exit
		end

feature {NONE} -- Events

	on_prepare
		local
			lib_dir: EL_DIR_PATH
		do
			Precursor
			OS.copy_tree (Eiffel_loop_dir.joined_dir_path ("doc-config"), Work_area_dir)
			OS.copy_file ("test-data/publish/config-1.pyx", Doc_config_dir)
			across << "dummy", "images", "css", "js" >> as name loop
				OS.copy_tree (Eiffel_loop_dir.joined_dir_steps (<< "doc", name.item >>), Doc_dir)
			end
			across (<<
				"library",
				"library/base",
				"library/text",
				"library/graphic",
				"library/graphic/toolkit"
			>>) as dir loop
				OS.File_system.make_directory (Work_area_dir.joined_dir_path (dir.item))
			end
			across (<<
				"library/base/data_structure",
				"library/base/math",
				"library/base/persistency",
				"library/text/i18n",
				"library/graphic/toolkit/html-viewer"
			>>) as dir loop
				lib_dir := dir.item
				OS.copy_tree (Eiffel_loop_dir.joined_dir_path (lib_dir), Work_area_dir.joined_dir_path (lib_dir.parent))
			end
			across (<<
				"library/base/base.ecf",
				"library/i18n.ecf",
				"library/html-viewer.ecf"
			>>) as path loop
				OS.copy_file (Eiffel_loop_dir + path.item, (Work_area_dir + path.item).parent)
			end
			Execution_environment.put ("workarea", "EIFFEL_LOOP")
			Execution_environment.put ("workarea/doc", "EIFFEL_LOOP_DOC")
		end

feature {NONE} -- Implementation

	check_html_exists (publisher: like new_publisher)
		local
			html_file_path: EL_FILE_PATH
		do
			across publisher.ecf_list as tree loop
				across tree.item.path_list as path loop
					html_file_path := Doc_dir + path.item.relative_path (publisher.root_dir).with_new_extension ("html")
					assert ("html exists", html_file_path.exists)
				end
			end
		end

	file_content_checksum: NATURAL
		local
			crc: EL_CYCLIC_REDUNDANCY_CHECK_32
		do
			create crc
			across generated_files as html loop
				crc.add_file (html.item)
			end
			Result := crc.checksum
		end

	generated_files: like OS.file_list
		do
			Result := OS.file_list (Doc_dir, "*.html")
		end

	file_modification_checksum: NATURAL
		local
			crc: EL_CYCLIC_REDUNDANCY_CHECK_32
			modification_time: DATE_TIME
		do
			create crc
			across OS.file_list (Doc_dir, "*.html") as html loop
				modification_time := html.item.modification_date_time
				crc.add_integer (modification_time.date.ordered_compact_date)
				crc.add_integer (modification_time.time.compact_time)
			end
			Result := crc.checksum
		end

	new_publisher: REPOSITORY_TEST_PUBLISHER
		do
			create Result.make (Doc_config_dir + "config-1.pyx", "1.4.0", 0)
		end

feature {NONE} -- Constants

	Modified_files: ARRAY [ZSTRING]
		once
			Result := << "base.data_structure.html", "el_hash_set.html", "index.html" >>
			Result.compare_objects
		end

	Doc_dir: EL_DIR_PATH
		once
			Result := Work_area_dir.joined_dir_path ("doc")
		end

	Doc_config_dir: EL_DIR_PATH
		once
			Result := Work_area_dir.joined_dir_path ("doc-config")
		end

	Hash_set_path: EL_FILE_PATH
		once
			Result := Work_area_dir + "library/base/data_structure/set/el_hash_set.e"
		end

end
