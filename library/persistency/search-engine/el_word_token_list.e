note
	description: "[
		A tokenized string which forms the basis of a fast full text search engine.
		The initializing string argument is decomposed into a series of lowercased words ignoring punctuation.
		The resulting word-list is represented as a series of token id's which are keys into a table of unique words.
		Each token is of type `CHARACTER_32'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-23 14:34:11 GMT (Saturday 23rd February 2019)"
	revision: "6"

class
	EL_WORD_TOKEN_LIST

inherit
	STRING_32
		rename
			make_from_string as make_from_tokens
		redefine
			out
		end

create
	make, make_empty, make_from_tokens

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
