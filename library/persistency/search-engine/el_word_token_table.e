note
	description: "[
		A table of unique words used to create tokenized strings or word-lists consisting of a series
		of keys into the word table.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-13 15:45:47 GMT (Wednesday 13th February 2019)"
	revision: "5"

class
	EL_WORD_TOKEN_TABLE

inherit
	EL_ZSTRING_TOKEN_TABLE
		redefine
			make
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

feature -- Conversion

	tokens_to_string (a_tokens: EL_TOKENIZED_STRING): ZSTRING
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

end
