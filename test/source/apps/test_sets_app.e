note
	description: "Test SET implementations"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-01 14:52:59 GMT (Thursday 1st January 2015)"
	revision: "4"

class
	TEST_SETS_APP

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
		do
--			test_part_sorted_set				-- BUG
--			test_arrayed_set					-- OK
--			test_binary_search_tree_set			-- OK
--			test_binary_search_tree_subtraction	-- BUG
			test_part_sorted_set_subtraction	-- BUG
--			test_GOBO_binary_tree_subtraction	-- BUG

		end

feature -- Test suite

	test_part_sorted_set
			--
		local
			i: INTEGER
			set: PART_SORTED_SET [STRING]
		do
			io.put_string ("test_part_sorted_set")
			io.put_new_line
			create set.make
			set.compare_objects
			from i := 1 until i > file_name_array.count loop
				set.put (file_name_array [i])
				io.put_string ("set.count: ")
				io.put_integer (set.count)
				io.put_new_line

				i := i + 1
			end

			-- FAILS element missing
			check
				all_elements_added_to_set: file_name_array.count = set.count
			end
			io.put_new_line
		end

	test_arrayed_set
			--
		local
			i: INTEGER
			set: ARRAYED_SET [STRING]
		do
			io.put_string ("test_arrayed_set")
			io.put_new_line
			create set.make (file_name_array.count)
			set.compare_objects
			from i := 1 until i > file_name_array.count loop
				set.put (file_name_array [i])
				io.put_string ("set.count")
				io.put_integer (set.count)
				io.put_new_line

				i := i + 1
			end
			io.put_new_line
		end

	test_binary_search_tree_set
			--
		local
			i: INTEGER
			set: BINARY_SEARCH_TREE_SET [STRING]
		do
			io.put_string ("test_binary_search_tree_set")
			io.put_new_line
			create set.make
			set.compare_objects
			from i := 1 until i > file_name_array.count loop
				set.put (file_name_array [i])
				io.put_string ("set.count:")
				io.put_integer (set.count)
				io.put_new_line

				i := i + 1
			end
			io.put_new_line
		end

	test_binary_search_tree_subtraction
			--
		local
			i: INTEGER
			set_A, set_B: BINARY_SEARCH_TREE_SET [STRING]
		do
			io.put_string ("test_binary_search_tree_subtraction")
			io.put_new_line
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
			io.put_string ("set_B.subtract (set_A)")
			io.put_new_line

			-- FAILS stuck in an infinite loop
			set_B.subtract (set_A)


			io.put_string ("DONE")
			io.put_new_line
			from set_B.start until set_B.after loop
				io.put_string (set_B.item)
				io.put_new_line
			end
			io.put_new_line
		end

	test_part_sorted_set_subtraction
			--
		local
			i, count: INTEGER
			set_A, set_B: PART_SORTED_SET [STRING]
		do
			io.put_string ("test_binary_search_tree_subtraction")
			io.put_new_line
			create set_A.make
			set_A.compare_objects

			create set_B.make
			set_B.compare_objects

			from i := 1 until i > file_name_array.count loop
				set_A.put (file_name_array [i])
				if i <= 2 then
					set_B.put (file_name_array [i])
				end
				i := i + 1
			end
			io.put_string ("set_B.subtract (set_A)")
			io.put_new_line

			set_B.subtract (set_A)

			io.put_string ("DONE")
			io.put_new_line
			from set_B.start until set_B.after loop
				io.put_string (set_B.item)
				io.put_new_line
				count := count + 1
			end

			-- FAILS
			check
				has_two_elements: count = 2
			end
			io.put_new_line
		end

	test_GOBO_binary_tree_subtraction
			--
		local
			i: INTEGER
			set_A, set_B: DS_RED_BLACK_TREE_SET [STRING]
			comparator: KL_COMPARABLE_COMPARATOR [STRING]
		do
			io.put_string ("test_GOBO_binary_tree_subtraction_1")
			io.put_new_line
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
			io.put_string ("set_B.subtract (set_A)")
			io.put_new_line

			-- FAILS with broken precondition
			set_B.subtract (set_A)


			io.put_string ("DONE")
			io.put_new_line
			from set_B.start until set_B.after loop
				io.put_string (set_B.item_for_iteration)
				io.put_new_line
			end
			io.put_new_line
		end


feature {NONE} -- Constants

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

	Option_name: STRING = "sets"

	Description: STRING = "Test SET implementations"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{TEST_SETS_APP}, All_routines]
			>>
		end


end
