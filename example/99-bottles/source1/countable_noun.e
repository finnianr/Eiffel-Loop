indexing
	description: "String representing a quantity"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	COUNTABLE_NOUN

inherit
	STRING
		rename
			make as make_word
		end

create
	make

feature {NONE} -- Implementation

	make (noun: STRING; quantity: INTEGER) is
			--
		do
			make_from_string (noun)
			if quantity /= 1 then
				append_character ('s')
			end
		end

end -- class COUNTABLE_NOUN
