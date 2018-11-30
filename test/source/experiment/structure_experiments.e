note
	description: "Structure experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-30 12:19:26 GMT (Friday 30th November 2018)"
	revision: "1"

class
	STRUCTURE_EXPERIMENTS

inherit
	EXPERIMENTAL

feature -- Basic operations

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
			extend_container (create {ARRAYED_LIST [EL_DIR_PATH]}.make (0))
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
			table: HASH_TABLE [STRING, INTEGER]
		do
			create table.make (10)
			across (1 |..| 10) as n loop
				table [n.item] := n.item.out
			end
			-- remove all items except number 1
			across table.current_keys as n loop
				if n.item = 5 then
					table.remove (n.item)
				end
			end
			across table as n loop
				lio.put_integer (n.key); lio.put_character (':'); lio.put_string (n.item)
				lio.put_new_line
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

feature {NONE} -- Implementation

	extend_container (container: LIST [EL_PATH])
		do
			container.extend (Directory.current_working)
		end

end
