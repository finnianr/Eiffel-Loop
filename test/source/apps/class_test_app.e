note
	description: "Class test app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-30 13:33:42 GMT (Saturday 30th June 2018)"
	revision: "6"

class
	CLASS_TEST_APP

inherit
	REGRESSION_TESTABLE_SUB_APPLICATION
		redefine
			Option_name
		end

	EL_MODULE_COMMAND

create
	make

feature -- Basic operations

	test_run
			--
		do
			ftp_directory_exists
		end

feature -- Tests

	ftp_directory_exists
		local
			ftp: EL_FTP_PROTOCOL
		do
			log.enter ("ftp_directory_exists")
			create ftp.make_write (create {FTP_URL}.make ("eiffel-loop.com"))
			ftp.set_home_directory ("/public/www")
			ftp.open; ftp.login
			ftp.change_home_dir
			lio.put_labeled_string ("ftp.directory_exists (%"example%")", ftp.directory_exists ("/public/www/example").out)
			lio.put_new_line
			ftp.close
			log.exit
		end

	part_sorted_set
			--
		local
			i: INTEGER
			set: PART_SORTED_SET [STRING]
		do
			log.enter ("part_sorted_set")
			create set.make
			set.compare_objects
			from i := 1 until i > file_name_array.count loop
				set.put (file_name_array [i])
				log.put_integer_field ("set.count", set.count)
				log.put_new_line

				i := i + 1
			end
			log.exit
		end

	arrayed_set
			--
		local
			i: INTEGER
			set: ARRAYED_SET [STRING]
		do
			log.enter ("arrayed_set")
			create set.make (file_name_array.count)
			set.compare_objects
			from i := 1 until i > file_name_array.count loop
				set.put (file_name_array [i])
				log.put_integer_field ("set.count", set.count)
				log.put_new_line

				i := i + 1
			end
			log.exit
		end

	binary_search_tree_set
			--
		local
			i: INTEGER
			set: BINARY_SEARCH_TREE_SET [STRING]
		do
			log.enter ("binary_search_tree_set")
			create set.make
			set.compare_objects
			from i := 1 until i > file_name_array.count loop
				set.put (file_name_array [i])
				log.put_integer_field ("set.count", set.count)
				log.put_new_line

				i := i + 1
			end
			log.exit
		end

	binary_search_tree_subtraction
			--
		local
			i: INTEGER
			set_A, set_B: BINARY_SEARCH_TREE_SET [STRING]
		do
			log.enter ("binary_search_tree_subtraction")
			create set_A.make
			set_A.compare_objects

			create set_B.make
			set_B.compare_objects

			from i := 1 until i > file_name_array.count loop
				set_A.put (file_name_array [i])
				if i /= 1 then
					set_B.put (file_name_array [i])
				end
				i := i + 1
			end
			log.put_line ("set_B.subtract (set_A)")
			set_B.subtract (set_A)
			log.put_line ("DONE")
			from set_B.start until set_B.after loop
				log.put_line (set_B.item)
			end
			log.exit
		end

	GOBO_binary_tree_subtraction_1
			--
		local
			i: INTEGER
			set_A, set_B: DS_RED_BLACK_TREE_SET [STRING]
			comparator: KL_COMPARABLE_COMPARATOR [STRING]
		do
			log.enter ("GOBO_binary_tree_subtraction")
			create comparator.make
			create set_A.make (comparator)
			create set_B.make (comparator)

			from i := 1 until i > file_name_array.count loop
				set_A.put (file_name_array [i])
				if i /= 1 then
					set_B.put (file_name_array [i])
				end
				i := i + 1
			end
			log.put_line ("set_B.subtract (set_A)")
			set_B.subtract (set_A)
			log.put_line ("DONE")
			from set_B.start until set_B.after loop
				log.put_line (set_B.item_for_iteration)
			end
			log.exit
		end

	GOBO_binary_tree_subtraction_2
			--
		local
			i: INTEGER
			set_A, set_B: DS_AVL_TREE_SET [STRING]
			comparator: KL_COMPARABLE_COMPARATOR [STRING]
		do
			log.enter ("GOBO_binary_tree_subtraction")
			create comparator.make
			create set_A.make (comparator)
			create set_B.make (comparator)

			from i := 1 until i > file_name_array.count loop
				set_A.put (file_name_array [i])
				if i /= 1 then
					set_B.put (file_name_array [i])
				end
				i := i + 1
			end
			log.put_line ("set_B.subtract (set_A)")
			set_B.subtract (set_A)
			log.put_line ("DONE")
			from set_B.start until set_B.after loop
				log.put_line (set_B.item_for_iteration)
			end
			log.exit
		end

	find_files_command_on_root
			--
		local
			find_files_cmd: like Command.new_find_files
		do
			log.enter ("find_files_command_on_root")
			find_files_cmd := Command.new_find_files ("/", "*.rc")
			find_files_cmd.set_depth (1 |..| 1)
			find_files_cmd.execute
			log.put_new_line
			from find_files_cmd.path_list.start until find_files_cmd.path_list.after loop
				log.put_line (find_files_cmd.path_list.item.to_string)
				find_files_cmd.path_list.forth
			end
			log.exit
		end

	hash_table_replace_key
			--
		do
			create map_pointer_to_string.make (3)
			map_pointer_to_string [Default_pointer + 5] := String_hello
			map_pointer_to_string.replace_key (Default_pointer + 10, Default_pointer + 5)
		ensure
			new_pointer_maps_to_same_string: map_pointer_to_string [Default_pointer + 10] = String_hello
		end

	String_hello: STRING =	"hello"

feature {NONE} -- Implementation

	file_path_array: ARRAY [STRING]
			--
		once
			Result := <<
				"C:/Program files/eiffel-loop",
				"/",
				"/home",
				"/home/finnian",
				"finnian"
			>>
		end

	file_name_array: ARRAY [STRING]
			--
		once
			Result := <<
				"Francisco Canaro - Pampa.mp3",
				"Francisco Canaro - Serenata maleva - 1931 Charlo.mp3",
				"Francisco Canaro - Yo no se que me han hecho tus ojos.mp3",
				"Francisco Canaro - Cambalache.mp3"
			>>
		end

	map_pointer_to_string: HASH_TABLE [STRING, POINTER]


feature {NONE} -- Constants

	Option_name: STRING = "class_test"

	Description: STRING = "Manual tests"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{CLASS_TEST_APP}, All_routines]
			>>
		end

end
