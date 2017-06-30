note
	description: "[
		2016 revised version of short application to generate lyrics for the song "99 Bottles of Beer"
		See: [http://www.99-bottles-of-beer.net]
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LYRICS_99_BOTTLES_OF_BEER

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			-- Output title + 2 line breaks using new-line control character '%N'
			print ("Lyrics of the song 99 Bottles of Beer%N%N")

			-- Integer interval iteration with agent iteration
			(0 |..| Maximum_bottles).do_all (
				agent (n: INTEGER)
						-- Anonymous agent
					local
						i: INTEGER
					do
						print (substituted_verse (variables (n)))

						-- Output 2 new lines
						from i := 1 until i > 2 loop
							io.put_new_line
							i := i + 1
						end
					end
			)
		end

feature -- Implementation

	bottle_expression (count: INTEGER): like substituted_verse
		-- return type is anchored to type of `substituted_verse'
		do
			-- Eiffel switch statement
			inspect count
				when 0 then
					Result := "no more bottles"

				when 1 then
					-- Integer converted to type `STRING' using universally inherited function `out' from class `ANY'
					Result := count.out + " bottle"

			else
				Result := count.out + " bottles"
			end
		end

	substituted_verse (a_variables: like variables): STRING_32
		require
			-- Precondition for routine
			same_number_of_unique_variables: a_variables.count = Template_variables.count
			all_template_variables_found_in_argument: across a_variables as variable all Template_variables.has (variable.key) end
		do
			Result := Template -- Implicit cloning of template using Eiffel conversion syntax

			-- container iteration
			across a_variables as variable loop
				Result.replace_substring_all (variable.key, variable.item)
			end
			Result.put (Result.item (1).as_upper, 1) -- Ensure first letter is always upper case

		ensure -- Post condition for routine
			all_variables_substituted: not Result.has ('$')
		end

	variables (consumed_count: INTEGER): HASH_TABLE [like bottle_expression, STRING]
			-- variable table for substituting into the verse template
		local
			remaining_count, i: INTEGER
		do
			remaining_count := Maximum_bottles - consumed_count

			-- Make hash table with key lookup using object comparison.
			-- i.e. keys are compared using universally inherited `is_equal' function from class ANY
			create Result.make_equal (3)
			Result [Var_count] := bottle_expression (remaining_count)
			Result [Var_remaining_count] := bottle_expression (Maximum_bottles - (consumed_count + 1) \\ (Maximum_bottles + 1))
			Result [Var_instruction] := Instructions [remaining_count.min (1) + 1]
		end

feature -- Constants

	Instructions: ARRAY [IMMUTABLE_STRING_32]
		-- Returns singleton array of unicode strings that cannot be changed (immutable)
		-- 'once' means the result is calculated only once. Subsequent calls return the same object
		once
			Result := << "Go to the store and buy some more", "Take one down and pass it around" >>
		end

	Template_variables: BINARY_SEARCH_TREE_SET [STRING]
			-- Set of unique substitution variables found in `Template'
		local
			l_word: STRING_32
		once
			create Result.make
			Result.compare_objects -- Ensure objects are compared using `is_equal' test

			across Template.split ('%N') as line loop -- split into lines
				across line.item.split (' ') as word loop -- split into words
					-- Strip any punctuation from end of word
					from
						l_word := word.item
					invariant
						not l_word.is_empty
					until
						l_word.is_empty or else not l_word.item (l_word.count).is_punctuation
					loop
						l_word.remove_tail (1)
					end
					if l_word [1] = '$' then
						Result.put (l_word) -- Implicit conversion of l_word to type STRING
					end
				end
			end
		ensure
			-- agent test for all objects in container
			all_variables_found: Result.linear_representation.for_all (agent variable_names.has)
		end

	Template: IMMUTABLE_STRING_32
		-- Verse template
		-- Returns singleton unicode string that cannot be changed (immutable)
		-- Example of multi-line manifest string that may contain unescaped quote marks.
		once
			Result := "[
				$COUNT of beer on the wall, $COUNT of beer.
				$INSTRUCTION, $REMAINING_COUNT of beer on the wall.
			]"
		ensure
			all_variables_found_in_template: across variable_names as name all Result.has_substring (name.item) end
		end

	Variable_names: ARRAY [STRING]
		do
			Result := << Var_count, Var_remaining_count, Var_instruction >>
			Result.compare_objects
		end

	Var_count: STRING = "$COUNT"
		-- Short hand syntax for 'once' string but cannot be over-ridden in a descendant class

	Var_remaining_count: STRING = "$REMAINING_COUNT"

	Var_instruction: STRING = "$INSTRUCTION"

	Maximum_bottles: INTEGER = 99

end
