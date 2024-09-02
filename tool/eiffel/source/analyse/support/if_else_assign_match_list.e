note
	description: "[
		Collect codes lines that could form an expression of type: `x := if <expr> then a else b end'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-01 14:52:19 GMT (Sunday 1st September 2024)"
	revision: "1"

class
	IF_ELSE_ASSIGN_MATCH_LIST

inherit
	EL_ZSTRING_LIST
		rename
			extend as extend_list
		redefine
			initialize, wipe_out
		end

	EL_EIFFEL_KEYWORDS

create
	make_empty

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			create identifier.make_empty
		end

feature -- Element change

	extend (line, word: ZSTRING; word_index: INTEGER; done: BOOLEAN_REF)
		do
			inspect count
				when 0 then
					if word ~ Keyword.if_ then
						extend_list (line.twin)
						done.set_item (True)
					end
				when 1 then
					if word_index = 1 then
						identifier.append (word)
					else
						if word ~ Assign_operator then
							extend_list (line.twin)
						end
						done.set_item (True)
					end
				when 2 then
					if word ~ Keyword.else_ then
						extend_list (line.twin)
					end
					done.set_item (True)
				when 3 then
					if word_index = 1 then
						if identifier /~ word then
							done.set_item (True)
							wipe_out
						end
					else
						if word ~ Assign_operator then
							extend_list (line.twin)
						end
						done.set_item (True)
					end
				when 4 then
					if word ~ Keyword.end_ then
						extend_list (line.twin)
					end
					done.set_item (True)
			else
				done.set_item (True)
			end
		end

	wipe_out
		do
			Precursor
			identifier.wipe_out
		end

feature {NONE} -- Internal attributes

	identifier: ZSTRING

end