note
	description: "Subject list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_SUBJECT_LIST

inherit
	EL_ZSTRING_LIST
		rename
			has as has_item,
			extend as extend_decoded
		export
			{NONE} all
			{ANY} last, wipe_out, is_empty, extendible
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			create line_set.make (n)
			create decoder.make
		end

feature -- Element change

	extend (encoded_line: ZSTRING)
		local
			line: ZSTRING
		do
			decoder.set_line (encoded_line)
			line := decoder.decoded_line
			extend_decoded (line)
			line_set.put (line)
		end

feature -- Status query

	has (line: ZSTRING): BOOLEAN
		do
			Result := line_set.has (line)
		end

feature {NONE} -- Internal attributes

	line_set: EL_HASH_SET [ZSTRING]

	decoder: EL_SUBJECT_LINE_DECODER

end