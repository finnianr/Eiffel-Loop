note
	description: "Summary description for {EL_STRING_X_ROUTINES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_STRING_X_ROUTINES [S -> STRING_GENERAL create make_empty, make end]

feature -- Transformation

	quoted (str: READABLE_STRING_GENERAL): S
			--
		do
			Result := enclosed (str, '%"', '%"')
		end

	enclosed (str: READABLE_STRING_GENERAL; left, right: CHARACTER_32): S
			--
		do
			create Result.make (str.count + 2)
			Result.append_code (left.natural_32_code)
			Result.append (str)
			Result.append_code (right.natural_32_code)
		end

	unbracketed (str: READABLE_STRING_GENERAL; left_bracket: CHARACTER_32): S
			-- Returns text enclosed in one of matching paired characters: {}, [], (), <>
		require
			valid_left_bracket: ({STRING_32} "{[(<").has (left_bracket)
		local
			right_chararacter: CHARACTER_32
			offset: NATURAL; left_index, right_index, i: INTEGER
			l_result: READABLE_STRING_GENERAL
		do
			create Result.make_empty

			if left_bracket = '(' then
				offset := 1
			else
				offset := 2
			end
			right_chararacter := (left_bracket.natural_32_code + offset).to_character_32
			left_index := str.index_of (left_bracket, 1)
			right_index := str.index_of (right_chararacter, left_index + 1)
			if left_index > 0 and then right_index > 0 and then right_index - left_index > 1 then
				l_result := str.substring (left_index + 1, right_index - 1)
				from i := 1 until i > l_result.count loop
					Result.append_code (l_result.code (i))
					i := i + 1
				end
			end
		end

end
