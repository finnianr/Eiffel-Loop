note
	description: "Summary description for {EL_PASS_PHRASE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_PASS_PHRASE

inherit
	STRING
		redefine
			make_from_string
		end

	EL_MODULE_CHARACTER
		undefine
			out, copy, is_equal
		end

create
	make_from_string

feature {NONE} -- Initialization

	make_from_string (s: READABLE_STRING_8)
			--
		do
			Precursor (s)
			security_score := score (s)
		end

feature -- Access

	security_score: INTEGER

	security_description: STRING
			--
		do
			if security_score > 0 then
				create Result.make_from_string (Security_description_words)
				Result.append (" ")
				Result.append (Password_strengths [security_score])
				Result.append (" (")
				Result.append_integer (security_score)
				Result.append (")")
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Implementation

	score (password: STRING): INTEGER
			--
		local
			i, upper_count, lower_count, numeric_count, other_count: INTEGER
			c: CHARACTER_8
		do
			from i := 1 until i > password.count loop
				c := password @ i
				if Character.is_latin1_upper (c)  then
					upper_count := upper_count + 1

				elseif Character.is_latin1_lower (c)  then
					lower_count := lower_count + 1

				elseif c.is_digit then
					numeric_count := numeric_count + 1

				else
					other_count := other_count + 1

				end
				i := i + 1
			end
			Result := Result + upper_count.min (1)
			Result := Result + lower_count.min (1)
			Result := Result + numeric_count.min (1)
			Result := Result + other_count.min (1)

			from i := 1 until i > Password_count_levels.count loop
				if password.count >= Password_count_levels [i] then
					Result := Result + 1
				end
				i := i + 1
			end
			Result := Result.min (Password_strengths.count)
		end
feature {NONE} -- Constants

	Password_count_levels: ARRAY [INTEGER]
			--
		once
			Result := << 8, 10, 12, 14, 16, 18 >>
		end

	Security_description_words: STRING
			--
		once
			Result := "Passphrase strength"
		end

	Password_strengths: ARRAY [STRING]
			--
		once
			create Result.make (1, 9)
			Result [1] := "is recklessly bad"
			Result [2] := "is very bad"
			Result [3] := "is bad"
			Result [4] := "is below average"
			Result [5] := "is average"
			Result [6] := "is above average"
			Result [7] := "is good"
			Result [8] := "is very good"
			Result [9] := "is excellent"
		end
end
