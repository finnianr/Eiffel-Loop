note
	description: "Test suite for SmartEiffel compatible array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	SE_ARRAY2_TEST_SET

inherit
	EL_EQA_TEST_SET

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("array_read_write", agent test_array_read_write)
		end

feature -- Tests

	test_array_read_write
		do
--			log.enter ("test_array_read_write")
--			do_test (5, 10, check_sum (5, 10))
			across 1 |..| 5 as height loop
				across 1 |..| 5 as width loop
					do_test (height.item, width.item, check_sum (height.item, width.item))
				end
			end
--			log.exit
		end

feature {NONE} -- Implementation

	array_sum (row_offset, col_offset: INTEGER; array: SE_ARRAY2 [INTEGER]): INTEGER
		local
			row, col: INTEGER
		do
			from row := 1 until row > array.height loop
				from col := 1 until col > array.width loop
					Result := Result + array [row_offset + row, col_offset + col]
					col := col + 1
				end
				row := row + 1
			end
		end

	check_sum (height, width: INTEGER): INTEGER
		local
			row, col: INTEGER
		do
			from row := 1 until row > height loop
				from col := 1 until col > width loop
					Result := Result + (row |<< 16) | col
					col := col + 1
				end
				row := row + 1
			end
		end

	do_test (height, width, a_check_sum: INTEGER)
		local
			array: SE_ARRAY2 [INTEGER]
		do
--			log.enter_with_args ("do_test", << height, width >>)
			across -3 |..| 3 as row_offset loop
				across -3 |..| 3 as col_offset loop
					create array.make (
						row_offset.item + 1, row_offset.item + height, col_offset.item + 1, col_offset.item + width
					)
					assert ("same width", width = array.width)
					assert ("same height", height = array.height)
					initialize (row_offset.item, col_offset.item, array)
					assert ("same sum", array_sum (row_offset.item, col_offset.item, array) = a_check_sum)
				end
			end
--			log.exit
		end

	initialize (row_offset, col_offset: INTEGER; array: SE_ARRAY2 [INTEGER])
		local
			row, col: INTEGER
		do
			from row := 1 until row > array.height loop
				from col := 1 until col > array.width loop
					array [row_offset + row, col_offset + col] := (row |<< 16) | col
					col := col + 1
				end
				row := row + 1
			end
		end

end