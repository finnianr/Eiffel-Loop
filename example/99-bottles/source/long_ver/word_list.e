indexing
	description: "Summary description for {WORD_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	WORD_LIST

inherit
	LINKED_LIST [STRING]
		rename
			first as first_word,
			item as word,
			i_th as i_th_word
		end

feature	-- Initialization

	make_from_string (str: STRING) is
			--
		do
			make
			append_string (str)
		end

feature -- Element change

	capitalize_first is
			-- Make first letter uppercase
		require
			at_least_one_character: first_word.count >= 1
		do
			if not is_empty then
				first_word.put ((first_word @ 1).as_upper, 1)
			end
		end

	append_string (str: STRING) is
			-- Inline agent demo
		do
			if {word_list: LIST [STRING_8]} str.split (' ') then
				word_list.do_all (
					agent (a_word: STRING) do extend (a_word) end
				)
			end
		end

	append_other (other: WORD_LIST) is
			--
		do
			other.do_all (agent extend)
		end

feature -- Status query

	first_is_upper: BOOLEAN is
			--
		do
			Result := not is_empty implies not first_word.item (1).is_alpha or else first_word.item (1).is_upper
		end

feature -- Output

	print_to_medium (io_medium: IO_MEDIUM) is
			--
		do
			from start until after loop
				if not isfirst then
					io_medium.put_character (' ')
				end
				io_medium.put_string (word)
				forth
			end
		end

end -- class WORD_LIST
