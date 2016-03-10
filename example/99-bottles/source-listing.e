class
	THE_99_BOTTLES_OF_BEER_APPLICATION

create
	make

feature {NONE} -- Initialization

	make is
			-- Run application.
		local
			lyrics: SONG_LYRICS
			bottle_count: INTEGER
		do
			print ("Lyrics of the song " + Max_bottles.out + " Bottles of Beer")
			io.put_new_line
			io.put_new_line

			create lyrics.make

			from
				bottle_count := Max_bottles
			invariant
				is_true: bottle_count + lyrics.verse_count = Max_bottles

			until bottle_count < 0 loop
				lyrics.new_verse

				lyrics.append_long_status_clause (bottle_count)
				lyrics.append_status_clause (bottle_count)
				lyrics.new_sentence

				bottle_count := bottle_count - 1

				if bottle_count < 0 then
					lyrics.append_go_to_the_store_clause
					lyrics.append_long_status_clause (Max_bottles)
				else
					lyrics.append_take_one_down_clause
					lyrics.append_long_status_clause (bottle_count)
				end
			end

			lyrics.print_to_medium (io.output)
		end

feature {NONE} -- Constants

	Max_bottles: INTEGER is 99

end -- class APPLICATION

class
	SONG_LYRICS

inherit
	LINKED_LIST [VERSE]
		rename
			make as make_list,
			count as verse_count,
			last as	last_verse
		end

create
	make

feature -- Initialization

	make is
			--
		do
			make_list
		end

feature -- Element change

	append_long_status_clause (bottle_count: INTEGER) is
			--
		local
			long_status: LONG_BOTTLE_STATUS_CLAUSE
		do
			long_status := bottle_count
			append_to_last_sentence (long_status)
		end

	append_status_clause (bottle_count: INTEGER) is
			--
		local
			status: BOTTLE_STATUS_CLAUSE
		do
			status := bottle_count
			append_to_last_sentence (status)
		end

	append_go_to_the_store_clause is

		do
			append_to_last_sentence ("Go to the store and buy some more")
		end

	append_take_one_down_clause is

		do
			append_to_last_sentence ("Take one down and pass it around")
		end

	append_to_last_sentence (clause: CLAUSE) is

		do
			if last_verse.last_sentence.is_empty then
				clause.capitalize_first
			end
			last_verse.last_sentence.extend (clause)
		end

feature -- Access

	new_verse is

		do
			extend (create {VERSE}.make)
			new_sentence
		end

	new_sentence is

		do
			last_verse.extend (create {SENTENCE}.make)
		end

feature -- Output		

	print_to_medium (io_medium: IO_MEDIUM) is
			--

		do
			do_all (agent {VERSE}.print_to_medium (io_medium))
		end

end -- class SONG_LYRICS

class
	VERSE

inherit
	LINKED_LIST [SENTENCE]
		rename
			last as last_sentence
		end

create
	make

feature -- Output

	print_to_medium (io_medium: IO_MEDIUM) is
			--
		do
			do_all (agent {SENTENCE}.print_to_medium (io_medium))
			io_medium.put_new_line
		end

end -- class VERSE

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
			str.split (' ').do_all (
				agent (a_word: STRING) do extend (a_word) end
			)
		end

	append_other (other: WORD_LIST) is
			--
		do
			other.do_all (agent extend)
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

class
	QUANTITY_EXPRESSION

inherit
	WORD_LIST
		rename
			make as make_list
		end

create
	make, make_from_tuple

convert
	make_from_tuple ({TUPLE [STRING, INTEGER]})

feature {NONE} -- Initialization	

	make (countable_noun: STRING; quantity: INTEGER) is
			--
		do
			make_list
			if quantity = 0 then
				append_string ("no more")
			else
				append_string (quantity.out)
			end
			extend (create {COUNTABLE_NOUN}.make (countable_noun, quantity))
		end

	make_from_tuple (args: TUPLE [STRING, INTEGER]) is
			--
		do
			make_list;
			(agent make).call (args)
		end

end -- class QUANTITY_EXPRESSION

class
	CLAUSE

inherit
	WORD_LIST

create
	make_from_string

convert
	make_from_string ({STRING})

end -- class CLAUSE

class
	BOTTLE_STATUS_CLAUSE

inherit
	CLAUSE
		rename
			make as make_empty
		end

create
	make

convert
	make ({INTEGER})

feature {NONE} -- Initialization

	make (quantity: INTEGER) is

		local
			bottle_quantity: QUANTITY_EXPRESSION
		do
			make_empty
			bottle_quantity := [Bottle_singular, quantity]
			append_other (bottle_quantity)
			append_string ("of beer")
		ensure
			correct_grammatical_form_for_zero_bottles:
				quantity = 0 implies i_th_word (1).as_lower.is_equal ("no") and i_th_word (3).is_equal (Bottle_plural)

			correct_plural_form_for_one_bottle:
				quantity = 1 implies i_th_word (2).is_equal (Bottle_singular)

			correct_plural_form_for_more_than_one_bottle:
				quantity > 1 implies i_th_word (2).is_equal (Bottle_plural)
		end

feature -- Constants

	Bottle_singular: STRING is "bottle"

	Bottle_plural: STRING is
			--
		once
			create Result.make_from_string (Bottle_singular)
			Result.append_character ('s')
		end

end -- class BOTTLE_STATUS_CLAUSE

class
	LONG_BOTTLE_STATUS_CLAUSE

inherit
	BOTTLE_STATUS_CLAUSE
		redefine
			make
		end

create
	make

convert
	make ({INTEGER})

feature {NONE} -- Initialization

	make (quantity: INTEGER) is

		do
			Precursor (quantity)
			append_string ("on the wall")
		end

end -- class LONG_BOTTLE_STATUS_CLAUSE

class
	COUNTABLE_NOUN

inherit
	STRING
		rename
			make as make_word
		end

create
	make

feature {NONE} -- Implementation

	make (noun: STRING; quantity: INTEGER) is
			--
		do
			make_from_string (noun)
			if quantity /= 1 then
				append_character ('s')
			end
		end

end -- class COUNTABLE_NOUN


