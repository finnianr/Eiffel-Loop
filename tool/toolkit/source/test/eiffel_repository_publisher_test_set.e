note
	description: "Summary description for {EIFFEL_REPOSITORY_PUBLISHER_TEST_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-12 11:38:14 GMT (Tuesday 12th July 2016)"
	revision: "8"

class
	EIFFEL_REPOSITORY_PUBLISHER_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		rename
			new_file_tree as new_empty_file_tree
		redefine
			on_prepare
		end

feature -- Tests

	test_publisher
		local
			publisher: EIFFEL_REPOSITORY_PUBLISHER
			html_file_path: EL_FILE_PATH; source_tree: REPOSITORY_SOURCE_TREE
			checksum: NATURAL
		do
			create publisher.make (Work_area_dir + "doc-config/config.pyx", "1.4.0")
			publisher.set_output_dir (Doc_dir)
			publisher.ftp_sync.ftp.set_default_state -- Turn off ftp
			publisher.tree_list.wipe_out
			across Sources as src loop
				create source_tree.make_with_name (publisher, src.key, Eiffel_loop_dir.joined_dir_path (src.item))
				publisher.tree_list.extend (source_tree)
			end

			publisher.execute
			across publisher.tree_list as tree loop
				across tree.item.path_list as path loop
					html_file_path := Doc_dir + path.item.relative_path (publisher.root_dir).with_new_extension ("html")
					assert ("html exists", html_file_path.exists)
				end
			end
			checksum := file_modification_checksum
			publisher.execute
			assert ("no file was modified", checksum = file_modification_checksum)
		end

feature {NONE} -- Events

	on_prepare
		do
			Precursor
			OS.copy_tree (Eiffel_loop_dir.joined_dir_path ("doc-config"), Work_area_dir)
			across << "dummy", "images", "css", "js" >> as name loop
				OS.copy_tree (Eiffel_loop_dir.joined_dir_steps (<< "doc", name.item >>), Doc_dir)
			end
		end

feature {NONE} -- Implementation

	file_modification_checksum: NATURAL
		local
			crc: EL_CYCLIC_REDUNDANCY_CHECK_32
			modification_time: DATE_TIME
		do
			create crc
			across OS.file_list (Doc_dir, "*.html") as html loop
				modification_time := html.item.modification_time
				crc.add_integer (modification_time.date.ordered_compact_date)
				crc.add_integer (modification_time.time.compact_time)
			end
		end

feature {NONE} -- Constants

	Sources: EL_HASH_TABLE [STRING, STRING]
		once
			create Result.make (<<
				["EROS server", "example/net/eros-server/source"],
				["Eiffel object reflection", "library/base/runtime/reflection"],
				["Eiffel Remote Object Server (EROS)", "library/network/eros"],
				["Basic Networking Classes", "library/network/base"]
			>>)
		end

	Doc_dir: EL_DIR_PATH
		once
			Result := Work_area_dir.joined_dir_path ("doc")
		end
end
