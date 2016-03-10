indexing
	description: "Summary description for {QUANTITY_EXPRESSION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

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
				if {qty_string: STRING} quantity.out then
					append_string (qty_string)
				end
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
