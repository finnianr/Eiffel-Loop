note
	description: "[
		A tokenized string which forms the basis of a fast full text search engine.
		The initializing string argument is decomposed into a series of lowercased words ignoring punctuation.
		The resulting word-list is represented as a series of token id's which are keys into a table of unique words.
		Each token is of type `CHARACTER_32'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-26 18:52:12 GMT (Saturday 26th August 2023)"
	revision: "9"

class
	WORD_TOKEN_LIST

inherit
	EL_WORD_TOKEN_LIST

create
	make

feature -- Access

	last_token: CHARACTER_32
		do
			if not is_empty then
				Result := item (count)
			end
		end

	out: STRING
		local
			i: INTEGER
		do
			create Result.make (count * 10)
			from i := 1 until i > count loop
				if i > 1 then
					Result.append (", ")
				end
				Result.append_natural_32 (code (i))
				i := i + 1
			end
		end

	to_hexadecimal_string: STRING
		local
			i: INTEGER
			hexadecimal: STRING
		do
			create Result.make (count * 4)
			from i := 1 until i > count loop
				if i > 1 then
					Result.append_character (' ')
				end
				hexadecimal := code (i).to_hex_string
				hexadecimal.prune_all_leading ('0')
				Result.append (hexadecimal)
				i := i + 1
			end
		end

feature -- Status query

	all_less_or_equal_to (token: CHARACTER_32): BOOLEAN
		-- `True' if all token characters are less than or equal to `token'
		local
			l_area: like area; l_count, i: INTEGER
		do
			Result := True; l_area := area; l_count := count
			from i := 0 until not Result or i = l_count loop
				Result := l_area [i] <= token
				i := i + 1
			end
		end
end