note
	description: "Summary description for {TEST_OS_COMMANDS_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-14 13:00:45 GMT (Wednesday 14th January 2015)"
	revision: "6"

class
	TEST_OS_COMMANDS_APP

inherit
	TEST_APPLICATION
		redefine
			Option_name
		end

create
	make

feature -- Basic operations

	test_run
			--
		local
			id3_dir: EL_DIR_PATH
		do
			id3_dir := "id3$"
			Test.set_binary_file_extensions (<< "mp3", "wav", "tag" >>)
			Test.do_file_tree_test (id3_dir, agent test_gvfs_copy_move_and_delete_files, 3560460545)
--			Test.do_file_tree_test (id3_dir, agent test_copy_move_and_delete_files, 3560460545)
--			Test.do_file_tree_test (id3_dir, agent test_find_files_and_directories, 235253851)
--			Test.do_file_tree_test (id3_dir, agent id3_info, 1135003487)
--			Test.do_file_tree_test (Path.directory_name ("wav"), agent mp3_writer, 1195281527)

--			Test.do_file_tree_test ("currencies", agent test_directory_name_encodings, 2889297196)

			Test.print_checksum_list -- Passed 7th Dec 2011
		end

feature -- Tests

	test_gvfs_copy_move_and_delete_files (dir_path: EL_DIR_PATH)
		local
			gvfs_volume: EL_GVFS_VOLUME
		do
			create gvfs_volume.make ("Mint1", False)
		end

	test_copy_move_and_delete_files (dir_path: EL_DIR_PATH)
			--
		local
			copy_command: EL_COPY_FILE_COMMAND; move_file_command: EL_MOVE_FILE_COMMAND
			delete_file_command, delete_tree_command: EL_DELETE_PATH_COMMAND
			make_dir_command: EL_MAKE_DIRECTORY_COMMAND
--			move_dir_command: EL_MOVE_D
		do
			log.enter ("copy_move_and_delete_files")
			create copy_command.make (dir_path + "crc53865.mp3", dir_path + "crc53865 (copy).mp3")
			copy_command.execute

			create make_dir_command.make (dir_path.joined_dir_path ("folder"))
			make_dir_command.execute

			create move_file_command.make (copy_command.destination_path, make_dir_command.directory_path)
			move_file_command.set_directory_destination
			move_file_command.execute

			create move_file_command.make (dir_path.joined_dir_path ("221"), dir_path.joined_dir_path ("folder"))
			move_file_command.set_directory_destination
			move_file_command.execute

			create delete_file_command.make (copy_command.source_path)
			delete_file_command.execute

			create copy_command.make (dir_path + "ozzy.tag", dir_path.joined_dir_path ("folder"))
			copy_command.set_file_destination
			copy_command.execute
			log_or_io.put_line ("Setting directory destination")
			copy_command.set_directory_destination
			copy_command.execute

			log.put_new_line
			create delete_tree_command.make (dir_path.joined_dir_path ("230"))
			delete_tree_command.execute
			log.exit
		end

	test_find_files_and_directories (dir_path: EL_DIR_PATH)
			--
		local
			find_files_command: EL_FIND_FILES_COMMAND
			find_directories_command: EL_FIND_DIRECTORIES_COMMAND
		do
			log.enter ("find_files_and_directories")
--			create find_files_command.make (Directory.joined_path (dir_path, "curry"), "*.tag")
			create find_files_command.make (dir_path, All_routines)
			find_files_command.exclude_path_containing_any_of (<< "ozzy" >>)
			find_files_command.exclude_path_ending (".mp3")
			execute_find_command ("Find files excluding */ozzy/* and *.mp3", find_files_command)

			create find_files_command.make (dir_path, All_routines)
			find_files_command.disable_recursion
			execute_find_command ("Find files non-recursively", find_files_command)

			create find_directories_command.make (dir_path)
			find_directories_command.exclude_path_containing ("230")
			execute_find_command ("Find directories excluding 230", find_directories_command)

			log.exit
		end

	test_directory_name_encodings (dir_path: EL_DIR_PATH)
			--
		local
			find_directories_command: EL_FIND_DIRECTORIES_COMMAND
		do
			create find_directories_command.make (dir_path)
			find_directories_command.disable_recursion
			execute_find_command ("Find currency directories non-recursively", find_directories_command)

			create find_directories_command.make (dir_path)
			execute_find_command ("Find currency directories recursively", find_directories_command)
		end

	test_id3_info (dir_path: EL_DIR_PATH)
			--
		local
			find_files_command: EL_FIND_FILES_COMMAND
		do
			log.enter ("id3_info")
			create find_files_command.make (dir_path, All_routines)
			find_files_command.execute

			find_files_command.path_list.do_all (agent extract_tag_info)

			log.exit
		end

	test_mp3_writer (dir_path: EL_DIR_PATH)
			--
		local
			wav_to_mp3_command: EL_WAV_TO_MP3_COMMAND
			l_id3_info: EL_ID3_INFO
		do
			log.enter ("mp3_writer")
			create wav_to_mp3_command.make (dir_path + "pop.wav", dir_path + "pop.mp3")
			create l_id3_info.make (wav_to_mp3_command.output_file_path)
			l_id3_info.set_genre ("Sound effect")
			l_id3_info.set_artist ("KDE")
			l_id3_info.set_album ("Ubuntu")
			l_id3_info.set_title ("Pop")
			l_id3_info.set_year (2008)
			l_id3_info.update

			wav_to_mp3_command.execute
			log.exit
		end

feature {NONE} -- Implementation

	execute_find_command (a_description: STRING; command: EL_FIND_OS_COMMAND [EL_FIND_COMMAND_IMPL, EL_PATH])
		do
			log.put_new_line
			log.put_line (a_description)
			command.execute
			across command.path_list as path loop
				log.put_path_field ("A", path.item)
				log.put_new_line
			end
		end

	extract_tag_info (id3_file_path: EL_FILE_PATH)
			--
		local
			fields: HASH_TABLE [STRING, STRING]
			extract_tag_info_command: EL_EXTRACT_ID3_TAGS_COMMAND
		do
			log.enter ("extract_tag_info")

			log.put_line (id3_file_path.to_string)
			log.put_new_line

			create extract_tag_info_command.make (id3_file_path)
			extract_tag_info_command.execute
			fields := extract_tag_info_command.fields
			from fields.start until fields.after loop
				log.put_string_field (fields.key_for_iteration, fields.item_for_iteration)
				log.put_new_line
				fields.forth
			end
			log.exit
		end

feature {NONE} -- Constants

	Option_name: STRING = "test_os_commands"

	Description: STRING = "Auto test OS command wrappers"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EL_TEST_ROUTINES}, All_routines],
				[{TEST_OS_COMMANDS_APP}, All_routines],
				[{EL_FIND_FILES_COMMAND}, All_routines],
				[{EL_FIND_DIRECTORIES_COMMAND}, All_routines],
				[{EL_COPY_FILE_COMMAND}, All_routines],
				[{EL_MOVE_FILE_COMMAND}, All_routines],
				[{EL_MAKE_DIRECTORY_COMMAND}, All_routines]
			>>
		end

end
