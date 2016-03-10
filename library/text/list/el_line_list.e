note
	description: "Summary description for {EL_LINE_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-30 8:25:00 GMT (Sunday 30th June 2013)"
	revision: "2"

class
	EL_LINE_LIST [S -> STRING_GENERAL create make_empty end]

inherit
	EL_LINEAR [S]

create
	make

feature {NONE} -- Initialization

	make (a_target: S)
			--
		do
			target := a_target
			delimiter := Default_delimiter
		end

feature -- Access

	index: INTEGER

	item: S
			--
		do
			if not after then
				Result := target.substring (pos_previous_separator + 1, pos_separator - 1)
			else
				create Result.make_empty
			end
		end

	delimiter: CHARACTER_32

feature -- Element change

	set_delimiter (a_delimiter: CHARACTER_32)
			--
		do
			delimiter := a_delimiter
		end

feature -- Cursor movement

	start
			-- Move to first position if any.
		do
			index := 0
			pos_previous_separator := 0
			pos_separator := 0
			after := false
			forth
		end

	forth
			-- Move to next position
		do
			if pos_separator > target.count then
				after := true
			else
				pos_previous_separator := pos_separator
				pos_separator := target.index_of (delimiter, pos_previous_separator + 1)
				if pos_separator = 0 then
					pos_separator := target.count + 1
				end
			end
			index := index + 1
		end

feature -- Status query

	after: BOOLEAN

	is_empty: BOOLEAN
			-- Is there no element?
		do
			Result := target.is_empty
		end

feature {NONE} -- Implementation

	target: S

	pos_separator: INTEGER

	pos_previous_separator: INTEGER

feature {NONE} -- Unused

	finish
			-- Move to last position.
		do
		end

feature {NONE} -- Constant

	Default_delimiter: CHARACTER = '%N'

end
