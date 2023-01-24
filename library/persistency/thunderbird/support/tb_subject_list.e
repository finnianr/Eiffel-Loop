note
	description: "Subject list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-24 21:23:53 GMT (Tuesday 24th January 2023)"
	revision: "9"

class
	TB_SUBJECT_LIST

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
		end

feature -- Element change

	extend (encoded_line: STRING)
		do
			extend_decoded (Subject_line.decoded (encoded_line))
			line_set.put (last)
		end

feature -- Status query

	has (line: ZSTRING): BOOLEAN
		do
			Result := line_set.has (line)
		end

feature {NONE} -- Internal attributes

	line_set: EL_HASH_SET [ZSTRING]

	Subject_line: TB_SUBJECT_LINE_DECODER
		once
			create Result.make
		end

end