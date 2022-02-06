note
	description: "Tests for class [$source FOLD_SEQUENCE] and [$source BOOLEAN_GRID]"
	author: "Finnian Reilly"

	copyright: "[
		Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly

		Gerrit Leder, Overather Str. 10, 51429 Bergisch-Gladbach, GERMANY
		gerrit.leder@gmail.com

		Finnian Reilly, Dunboyne, Co Meath, Ireland.
		finnian@eiffel-loop.com
	]"
	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"

class
	BOOLEAN_GRID_TEST_SET

inherit
	EQA_TEST_SET

	EL_MODULE_LOG

	DIRECTION_ROUTINES undefine default_create end

	POINT_SET_CONSTANTS undefine default_create end

	BOOLEAN_CONSTANTS undefine default_create end

feature -- Tests

	test_fold_sequence
		local
			sequence: FOLD_SEQUENCE; string_sequence: STRING
			c_last, c_second_last: CHARACTER; j: INTEGER
		do
			log.enter ("test_fold_sequence")
			across Sequences as seq loop
				create sequence.make (0)
				create string_sequence.make_empty
				log.put_integer_field ("seq", seq.cursor_index)
				log.put_new_line
				across 1 |..| 12 as i loop
					log.put_integer_field ("n", i.item)
					log.put_new_line
					across seq.item as c loop
						string_sequence.extend (c.item)
						sequence.extend (letter_as_natural_64 (c.item))
					end
					assert ("same sequence", string_sequence ~ sequence.to_string)
					assert ("same count " + string_sequence, string_sequence.count = sequence.count)
					from j := 1 until j > string_sequence.count loop
						c_last := string_sequence [j]
						assert ("same direction at pos: " + j.out, letter_as_natural_64 (c_last) = sequence.i_th (j) )
						j := j + 1
					end
					sequence.finish
					c_second_last := string_sequence [string_sequence.count - 1]
					assert ("same penultimate item", c_second_last ~ direction_letter (sequence.item_1))
					c_last := string_sequence [string_sequence.count]
					assert ("same last item", c_last ~ direction_letter (sequence.item_2))
				end
				string_sequence := string_sequence.mirrored
				from j := 1 until j > string_sequence.count loop
					sequence.put_i_th (letter_as_natural_64 (string_sequence [j]), j)
					j := j + 1
				end
				assert ("same mirrored sequence", string_sequence ~ sequence.to_string)
				log.put_new_line
			end
			log.exit
		end

	test_losses
		local
			grid: BOOLEAN_GRID; direction_bit, set: NATURAL; losses, i, cursor_index: INTEGER
		do
			log.enter ("test_losses")
			across <<
				Points_E_S, Points_E_S_W, Points_E_W, Points_N_E, Points_N_E_S, Points_N_E_W,
				Points_N_S, Points_N_S_W, Points_N_W, Points_S_W
			>> as point_set loop
				cursor_index := point_set.cursor_index
				set := point_set.item
				grid := new_grid
				grid.initialize (one)
				grid.go_to (2, 2)

				losses := 0
				direction_bit := Point_N -- North
				from i := 1 until i > 4 loop
					if (set & direction_bit).to_boolean then
						assert ("same losses", grid.losses (set) = losses)
						inspect i
							when 1 then
								grid.put (zero, 1, 2) -- N
							when 2 then
								grid.put (zero, 2, 3) -- E
							when 3 then
								grid.put (zero, 3, 2) -- S
							when 4 then
								grid.put (zero, 2, 1) -- W
						else end
						assert ("losses increases by one", grid.losses (set) = losses + 1)
						losses := losses + 1
					end
					direction_bit := direction_bit |>> 1
					i := i + 1
				end
			end

			log.exit
		end

feature {NONE} -- Implementation

	new_grid: BOOLEAN_GRID
		do
			create Result.make_filled (True, 3, 3)
		end

feature {NONE} -- Constants

	Sequences: ARRAY [STRING]
		once
			Result := << "NE", "NES", "NESW" >>
		end

end
