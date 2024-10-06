note
	description: "[
		A table of unique words used to create tokenized strings or word-lists consisting of a series
		of keys into the word table.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-06 10:50:36 GMT (Sunday 6th October 2024)"
	revision: "21"

class
	EL_WORD_TOKEN_TABLE

inherit
	EL_ZSTRING_TOKEN_TABLE
		redefine
			make, put
		end

	EL_CHARACTER_32_CONSTANTS

	EL_ZSTRING_CONSTANTS

create
	make

feature -- Initialization

	make (n: INTEGER)
			--
		do
			Precursor (n)
			create on_new_token_list.make
			put (New_line) -- paragraph separator for `New_line_token'
		end

feature -- Access

	New_line_token: CHARACTER_32 = '%/01/'

	on_new_token_list: EL_EVENT_BROADCASTER

feature -- Status query

	valid_token_list (tokens: EL_WORD_TOKEN_LIST; paragraph_list: EL_CHAIN [ZSTRING]): BOOLEAN
		-- quick check to make sure `tokens' meets basic conditions to be valid
		local
			last_word_lower: ZSTRING; s: EL_ZSTRING_ROUTINES
			non_empty_count, last_word_start_index, last_word_end_index, last_index: INTEGER
		do
			-- Iterate in reverse to find last non empty line
			-- and count number of non empty lines
			across paragraph_list.new_cursor.reversed as paragraph loop
				if paragraph.item.has_alpha_numeric then
					non_empty_count := non_empty_count + 1
					if last_word_start_index = 0 then
						last_word_start_index := s.last_word_start_index (paragraph.item, $last_word_end_index)
						last_index := paragraph_list.count - paragraph.cursor_index + 1
					end
				end
			end

			if last_word_start_index > 0 then
				last_word_lower := paragraph_list [last_index].substring (last_word_start_index, last_word_end_index)
				last_word_lower.to_lower
			else
				last_word_lower := Empty_string
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
			i: INTEGER; word: ZSTRING
		do
			Result := Once_token_list; Result.wipe_out
			create word.make (12)
			if attached Once_interval_list as interval_list then
				across paragraph_list as paragraph loop
					if attached paragraph.item as str then
						str.fill_alpha_numeric_intervals (interval_list)
						if interval_list.count > 0 then
							if Result.count > 0 then
								Result.extend (New_line_token)
							end
							if attached interval_list.area as a then
								from i := 0 until i = a.count loop
									word.wipe_out
									word.append_substring (str, a [i], a [i + 1])
									word.to_lower
									put (word)
									Result.extend (last_token)
									i := i + 2
								end
							end
						end
					end
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

feature {NONE} -- Constants

	Once_token_list: EL_WORD_TOKEN_LIST
		once
			create Result.make_empty
		end

	Once_interval_list: EL_ARRAYED_INTERVAL_LIST
		once
			create Result.make_empty
		end

end