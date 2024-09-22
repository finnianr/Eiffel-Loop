note
	description: "Structure experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:50:48 GMT (Sunday 22nd September 2024)"
	revision: "12"

class
	STRUCTURE_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_DIRECTORY

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
			>>)
		end

feature -- Tests

feature -- Basic operations

	arrayed_set
			--
		local
			i: INTEGER; set: ARRAYED_SET [STRING]
		do
			create set.make (Names.count)
			set.compare_objects
			from i := 1 until i > Names.count loop
				set.put (Names [i])
				lio.put_integer_field ("set.count", set.count)
				lio.put_new_line

				i := i + 1
			end
		end

	binary_search_tree_set
			--
		local
			i: INTEGER
			set: BINARY_SEARCH_TREE_SET [STRING]
		do
			create set.make
			set.compare_objects
			from i := 1 until i > Names.count loop
				set.put (Names [i])
				lio.put_integer_field ("set.count", set.count)
				lio.put_new_line

				i := i + 1
			end
		end

	binary_search_tree_subtraction
			--
		local
			i: INTEGER
			set_A, set_B: BINARY_SEARCH_TREE_SET [STRING]
		do
			create set_A.make
			set_A.compare_objects

			create set_B.make
			set_B.compare_objects

			from i := 1 until i > Names.count loop
				set_A.put (Names [i])
				if i /= 1 then
					set_B.put (Names [i])
				end
				i := i + 1
			end
			lio.put_line ("set_B.subtract (set_A)")
			set_B.subtract (set_A)
			lio.put_line ("DONE")
			from set_B.start until set_B.after loop
				lio.put_line (set_B.item)
			end
		end

	circular_list_iteration
		local
			list: ARRAYED_CIRCULAR [INTEGER]
		do
			create list.make (3)
			across 1 |..| 3 as n loop
				list.extend (n.item)
			end
			list.do_all (agent (n: INTEGER)
				do
					lio.put_integer (n)
					lio.put_new_line
				end
			)
		end

	circular_removal
		local
			list: TWO_WAY_CIRCULAR [STRING]
		do
			create list.make
			list.extend ("a")
			list.extend ("b")
--			list.extend ("c")

			list.start
			list.remove
			list.start
			lio.put_string_field ("first item", list.item)
			lio.put_new_line
		end

	container_extension
		do
			extend_container (create {ARRAYED_LIST [DIR_PATH]}.make (0))
		end

	create_smart_eiffel_compatible_array
		local
			array: SE_ARRAY2 [INTEGER]
		do
			create array.make_row_columns (2, 3)
		end

	find_iteration_order_of_linked_queue
			--
		local
			queue: LINKED_QUEUE [INTEGER]
		do
			create queue.make
			queue.extend (1)
			queue.extend (2)
			queue.extend (3)
			queue.linear_representation.do_all (
				agent (n: INTEGER) do
					lio.put_integer (n)
					lio.put_new_line
				end
			)
		end

	finite_iteration
		local
			part_array: ARRAY [INTEGER]
			finite: FINITE [INTEGER]; list: LINEAR [INTEGER]
		do
			create part_array.make_filled (0, 3, 4)
			part_array [3] := 3
			part_array [4] := 4
			finite := part_array
			list := finite.linear_representation
			from list.start until list.after loop
				lio.put_integer_field (list.index.out, list.item)
				lio.put_new_line
				list.forth
			end
		end

	hash_table_plus
		local
			table: EL_STRING_HASH_TABLE [INTEGER, STRING]
		do
			table := table + ["one", 1]
		end

	hash_table_reference_lookup
		local
			table: HASH_TABLE [INTEGER, STRING]
			one, two, three, four, five: STRING
			numbers: ARRAY [STRING]
		do
			one := "one"; two := "two"; three := "three"; four := "four"; five := "five"
			numbers := << one, two, three, four, five >>
			create table.make (5)
			across numbers as n loop
				table [n.item] := n.cursor_index
			end
			across numbers as n loop
				lio.put_integer_field (n.item, table [n.item])
				lio.put_new_line
			end
			across numbers as n loop
				n.item.wipe_out
			end
			across numbers as n loop
				lio.put_integer_field (n.item, table [n.item])
				lio.put_new_line
			end
		end

	hash_table_removal
		local
			table: EL_HASH_TABLE [STRING, INTEGER]
		do
			create table.make (10)
			across (1 |..| 10) as n loop
				table [n.item] := n.item.out
			end
			-- remove all items except number 1
			across table.key_list as n loop
				if n.item = 5 then
					table.remove (n.item)
				end
			end
			across table as n loop
				lio.put_integer (n.key); lio.put_character (':'); lio.put_string (n.item)
				lio.put_new_line
			end
		end

	hash_table_replace_key
			--
		local
			table: HASH_TABLE [STRING, POINTER]
		do
			create table.make (3)
			table [Default_pointer + 5] := String_hello
			table.replace_key (Default_pointer + 10, Default_pointer + 5)
			check
				new_pointer_maps_to_same_string: table [Default_pointer + 10] = String_hello
			end
		end

	initialize_named_array
		local
			named: EL_NAMED [ZSTRING]
		do

		end

	part_sorted_set
			--
		local
			set: PART_SORTED_SET [STRING]
			i: INTEGER
		do
			create set.make
			set.compare_objects
			from i := 1 until i > Names.count loop
				set.put (Names [i])
				lio.put_integer_field ("set.count", set.count)
				lio.put_new_line

				i := i + 1
			end
		end

	remove_from_list
		local
			my_list: TWO_WAY_LIST [INTEGER]
			i: INTEGER
		do
			create my_list.make
			from i := 1
			until i > 9
			loop
				my_list.extend (i)
				i := i + 1
			end
			print ("%NList contents: ")
			across my_list as m loop print (m.item.out + " ") end

			print ("%NRemoving item where contents = 3 within across")
			from my_list.start until my_list.exhausted loop
				my_list.prune (3)
			end
--			across my_list as m loop
--				if m.item.is_equal (3) then
--					my_list.go_i_th (m.cursor_index)
--					my_list.remove; my_list.back
--				end
--				print ("%Nloop number " + m.target_index.out)
--			end
			print ("%N(across loop is terminated after element removal)")
			print ("%N3 removed correctly, List contents: ")
			across my_list as m loop print (m.item.out + " ") end
			print ('%N')

		end

	special_twin
		-- find out what happens if you twin array that is not full
		-- Answer: the capacity is reduced to count
		local
			area_1, area: SPECIAL [CHARACTER]
		do
			create area_1.make_empty (6)
			area_1.extend ('a')
			area_1.extend ('b')
			area_1.extend ('c')
			area := area_1.twin
			lio.put_labeled_string ("same capacity", (area.capacity = area_1.capacity).out)
			lio.put_new_line
			area := area_1.resized_area (area_1.count)
			lio.put_labeled_string ("same capacity", (area.capacity = area_1.capacity).out)
			lio.put_new_line
		end

feature {NONE} -- Implementation

	extend_container (container: LIST [EL_PATH])
		do
			container.extend (Directory.current_working)
		end

feature {NONE} -- Constants

	Names: ARRAY [STRING]
			--
		once
			Result := <<
				"Pampa.mp3",
				"Serenata maleva - 1931 Charlo.mp3",
				"Yo no se que me han hecho tus ojos.mp3",
				"Cambalache.mp3"
			>>
		end

	Named_array: ARRAY [EL_NAMED [DATE_TIME]]
		once
			Result := << ["now", create {DATE_TIME}.make_now] >>
		end

	String_hello: STRING =	"hello"

end