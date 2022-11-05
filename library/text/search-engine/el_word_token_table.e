note
	description: "[
		A table of unique words used to create tokenized strings or word-lists consisting of a series
		of keys into the word table.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-05 8:16:36 GMT (Saturday 5th November 2022)"
	revision: "14"

class
	EL_WORD_TOKEN_TABLE

inherit
	EL_ZSTRING_TOKEN_TABLE
		redefine
			make, put
		end

	EL_ZSTRING_CONSTANTS

create
	make

feature -- Initialization

	make (n: INTEGER)
			--
		local
			s: EL_ZSTRING_ROUTINES
		do
			Precursor (n)
			create on_new_token_list.make
			put (s.character_string ('%N')) -- paragraph separator for `New_line_token'
		end

feature -- Access

	New_line_token: CHARACTER_32 = '%/01/'

	on_new_token_list: EL_EVENT_BROADCASTER

feature -- Status query

	valid_token_list (tokens: EL_WORD_TOKEN_LIST; paragraph_list: EL_CHAIN [ZSTRING]): BOOLEAN
		-- quick check to make sure `tokens' meets basic conditions to be valid
		local
			last_word_lower: ZSTRING; non_empty_count: INTEGER; s: EL_ZSTRING_ROUTINES
		do
			last_word_lower := Empty_string
			-- Iterate in reverse to find last non empty line
			-- and count number of non empty lines
			across paragraph_list.new_cursor.reversed as paragraph loop
				if s.has_alpha_numeric (paragraph.item) then
					non_empty_count := non_empty_count + 1
					if last_word_lower.is_empty then
						last_word_lower := s.last_word (paragraph.item)
						last_word_lower.to_lower
					end
				end
			end
			search (last_word_lower)
			if found
				and then last_token = tokens.last_token
				and then tokens.occurrences (New_line_token) + 1 = non_empty_count
				and then tokens.all_less_or_equal_to (count.to_character_32)
			then
				Result := True
			end
		end

feature -- Element change

	put (word: ZSTRING)
		local
			exception: EXCEPTION
		do
			search (word)
			if not found then
				if word.has ('%U') then
					create exception
					exception.set_description ("Invalid word: " + word)
					exception.raise
				else
					word_list.extend (word.twin)
					extend (word_list.count, word_list.last)
					last_code := count
				end
			end
		ensure then
			valid_last_word: word_list.last.is_valid
		end

feature -- Conversion

	paragraph_tokens (paragraph: ZSTRING): EL_WORD_TOKEN_LIST
		do
			Result := paragraph_list_tokens (<< paragraph >>)
		end

	paragraph_list_tokens (paragraph_list: ITERABLE [ZSTRING]): EL_WORD_TOKEN_LIST
		local
			s: EL_ZSTRING_ROUTINES; i: INTEGER; word, str: ZSTRING
		do
			Result := Once_token_list; Result.wipe_out
			create word.make (12)
			across paragraph_list as paragraph loop
				str := paragraph.item
				if s.has_alpha_numeric (str) then
					if not Result.is_empty then
						Result.extend (New_line_token)
					end
					from i := 1 until i > str.count loop
						if str.is_alpha_numeric_item (i) then
							word.append_z_code (str.z_code (i))
						else
							extend_list (Result, word)
						end
						i := i + 1
					end
					extend_list (Result, word)
				end
			end
			Result := Result.twin
			on_new_token_list.notify
		end

	tokens_to_string (a_tokens: EL_WORD_TOKEN_LIST): ZSTRING
		do
			Result := joined (a_tokens, ' ')
		end

feature -- Status change

	set_restored
		do
			is_restored := True
		end

feature -- Status report

	is_restored: BOOLEAN
		-- `True' if state is successfully restored from previous application session

feature {EL_WORD_SEARCHABLE} -- Implementation

	extend_list (list: EL_WORD_TOKEN_LIST; word: ZSTRING)
		do
			if not word.is_empty then
				word.to_lower
				put (word)
				list.extend (last_token)
				word.wipe_out
			end
		end

feature {NONE} -- Constants

	Once_token_list: EL_WORD_TOKEN_LIST
		once
			create Result.make_empty
		end

end