note
	description: "Summary description for {WORD_TOKEN_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 8:06:31 GMT (Wednesday 16th December 2015)"
	revision: "1"

class
	EL_WORD_TOKEN_TABLE

inherit
	EL_UNIQUE_CODE_TABLE [ZSTRING]
		export
			{ANY} is_empty, count
		redefine
			put, make
		end

create
	make

feature -- Initialization

	make (n: INTEGER)
			--
		do
			Precursor (n)
			create words.make (n)
		end

feature -- Access

	words: ARRAYED_LIST [ZSTRING]

feature -- Element change

	put (word: ZSTRING)
			--
		do
			Precursor (word)
			if not found then
				words.extend (word)
			end
		ensure then
			same_count: count = words.count
		end

feature -- Basic operations

	flush
		do
		end

feature -- Conversion

	tokens_to_string (tokens: EL_TOKENIZED_STRING): ZSTRING
		local
			i: INTEGER
		do
			create Result.make_empty
			from i := 1 until i > tokens.count loop
				if i > 1 then
					Result.append_character (' ')
				end
				Result.append (words [tokens.item (i).code])
				i := i + 1
			end
		end

feature -- Status change

	set_restored
		do
			is_restored := True
		end

feature -- Status report

	is_restored: BOOLEAN
		-- Is state restored from previous application session.

end