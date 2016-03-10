indexing
	description: "Verse sentence"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	SENTENCE

inherit
	LINKED_LIST [CLAUSE]
		rename
			item as clause,
			extend as extend_list
				-- Workaround for a bug in 6.3, fixed in 6.4 (inherited precondition not reached)
		end

create
	make

feature -- Element change

	extend (a_clause: like clause) is
			--
		require
			first_sentence_starts_with_capital_letter:
				is_empty implies not a_clause.i_th_word (1).item (1).is_alpha or else a_clause.i_th_word (1).item (1).is_upper
		do
			extend_list (a_clause)
		end

feature -- Basic operations

	print_to_medium (io_medium: IO_MEDIUM) is
			--
		do
			from start until after loop
				if not isfirst then
					io_medium.put_string (", ")
				end
				clause.print_to_medium (io_medium)
				forth
			end
			io_medium.put_string (".")
			io_medium.put_new_line
		end

end -- class SENTENCE
