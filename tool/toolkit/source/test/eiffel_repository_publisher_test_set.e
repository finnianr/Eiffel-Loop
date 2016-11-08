note
	description: "Summary description for {EIFFEL_REPOSITORY_PUBLISHER_TEST_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-12 7:54:32 GMT (Wednesday 12th October 2016)"
	revision: "2"

class
	EIFFEL_REPOSITORY_PUBLISHER_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		rename
			new_file_tree as new_empty_file_tree
		redefine
			on_prepare
		end

	EL_MODULE_USER_INPUT
		undefine
			default_create
		end

feature -- Tests

	test_publisher
		local
			publisher: EIFFEL_REPOSITORY_PUBLISHER
			html_file_path: EL_FILE_PATH; source_tree: REPOSITORY_SOURCE_TREE
			checksum: NATURAL; n: INTEGER
		do
			log.enter ("test_publisher")
			create publisher.make (Work_area_dir + "doc-config/config.pyx", "1.4.0")
			publisher.set_output_dir (Doc_dir)
			publisher.ftp_sync.ftp.set_default_state -- Turn off ftp
			publisher.tree_list.wipe_out
			across Sources as src loop
				create source_tree.make_with_name (publisher, src.key, Eiffel_loop_dir.joined_dir_path (src.item.source_dir))
				if not src.item.description.is_empty then
					source_tree.set_description_lines (src.item.description)
				end
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
			n := User_input.integer ("Return to finish")
			log.exit
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
				modification_time := html.item.modification_date_time
				crc.add_integer (modification_time.date.ordered_compact_date)
				crc.add_integer (modification_time.time.compact_time)
			end
		end

feature {NONE} -- Constants

	Sources: EL_HASH_TABLE [TUPLE [source_dir, description: STRING], STRING]
		once
			create Result.make_equal (7)
			Result ["Eiffel object reflection"] := ["library/base/runtime/reflection", "[
				See class [./library/base/runtime/reflection/el_reflection.html EL_REFLECTION]
			]"]

			Result ["Eiffel Remote Object Server (EROS)"] := ["library/network/eros", ""]

			Result ["Basic Networking Classes"] := ["library/network/base", "[
				* Basic client-server classes
				* Class to find network MAC address
			]"]

			Result ["Vision 2 override"] := ["library/override/graphic/toolkit/vision2", ""]
			Result ["C callbacks"] := ["library/language_interface/C/eiffel-callback", ""]

			Result ["Submission for 99-bottles-of-beer.net"] := ["example/99-bottles/source", "[
				Eiffel submission for [http://www.99-bottles-of-beer.net/ www.99-bottles-of-beer.net].
				
				This website contains sample programs for over 1500 languages and variations, all of
				which print the lyrics of the song "99 Bottles of Beer" using.
				
				**ECF:** ninety-nine-bottles.ecf
			]"]

			Result ["Eiffel Development Tools"] := ["tool/toolkit/source/applications/eiffel-dev", ""]
			Result ["SMIL class test"] := ["test/source/xml-to-eiffel-object-builder/smil", ""]
		end

	Doc_dir: EL_DIR_PATH
		once
			Result := Work_area_dir.joined_dir_path ("doc")
		end
end
