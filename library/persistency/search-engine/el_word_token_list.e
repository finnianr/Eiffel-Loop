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
	date: "2019-02-22 22:01:54 GMT (Friday 22nd February 2019)"
	revision: "5"

class
	EL_WORD_TOKEN_LIST

inherit
	STRING_32
		rename
			string as string_tokens,
			make_from_string as make_from_tokens
		redefine
			out
		end

create
	make, make_empty, make_from_tokens

feature -- Access

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

end
