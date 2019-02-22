note
	description: "[
		A table of unique words used to create tokenized strings or word-lists consisting of a series
		of keys into the word table.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-22 22:07:27 GMT (Friday 22nd February 2019)"
	revision: "6"

class
	EL_WORD_TOKEN_TABLE

inherit
	EL_ZSTRING_TOKEN_TABLE
		redefine
			make, put
		end

	EL_NOTIFYABLE
		rename
			make_default as make_notifyable
		undefine
			is_equal, copy
		end

create
	make

feature -- Initialization

	make (n: INTEGER)
			--
		do
			Precursor (n)
			make_notifyable
		end

feature -- Access

	Paragraph_separator: CHARACTER_32 = '%/01/'

feature -- Status query

	is_incomplete (tokens: EL_WORD_TOKEN_LIST): BOOLEAN
		-- True if table has some missing values
		local
			i: INTEGER; word_list_count: NATURAL
		do
			word_list_count := word_list.count.to_natural_32
			from i := 1 until Result or i > tokens.count loop
				Result := tokens.code (i) > word_list_count
				i := i + 1
			end
		end

feature -- Element change

	put (a_word: ZSTRING)
		local
			word: ZSTRING; exception: EXCEPTION
		do
			if a_word.has ('%U') then
				create exception
				exception.set_description ("Invalid word: " + a_word)
				exception.raise
			end
			search (a_word)
			if not found then
				word := a_word.twin
				extend (count + 1, word)
				last_code := count
				word_list.extend (word)
			end
		end

feature -- Conversion

	paragraph_tokens (paragraph: ZSTRING): EL_WORD_TOKEN_LIST
		do
			Result := paragraph_list_tokens (<< paragraph >>)
		end

	paragraph_list_tokens (paragraph_list: ITERABLE [ZSTRING]): EL_WORD_TOKEN_LIST
		local
			i: INTEGER; word, str: ZSTRING
		do
			Result := Once_token_list; Result.wipe_out
			create word.make (12)
			across paragraph_list as paragraph loop
				str := paragraph.item
				if not Result.is_empty then
					Result.extend (Paragraph_separator)
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
			Result := Result.twin
			notify
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
		-- Is state restored from previous application session.

feature {NONE} -- Implementation

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

	New_paragraph_symbol: ZSTRING
		once
			Result := "<*>"
		end

	Once_token_list: EL_WORD_TOKEN_LIST
		once
			create Result.make_empty
		end

end
