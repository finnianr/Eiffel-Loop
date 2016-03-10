indexing
	description: "Quantity description of remaining bottles"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	BOTTLE_STATUS_CLAUSE

inherit
	CLAUSE
		rename
			make as make_empty
		end

create
	make

convert
	make ({INTEGER})

feature {NONE} -- Initialization

	make (quantity: INTEGER) is

		local
			bottle_quantity: QUANTITY_EXPRESSION
			tuple: TUPLE [STRING, INTEGER]
		do
			make_empty
			tuple := [Bottle_singular, quantity]
			bottle_quantity := tuple
			append_other (bottle_quantity)
			append_string ("of beer")
		ensure
			correct_grammatical_form_for_zero_bottles:
				quantity = 0 implies i_th_word (1).as_lower.is_equal ("no") and i_th_word (3).is_equal (Bottle_plural)

			correct_plural_form_for_one_bottle:
				quantity = 1 implies i_th_word (2).is_equal (Bottle_singular)

			correct_plural_form_for_more_than_one_bottle:
				quantity > 1 implies i_th_word (2).is_equal (Bottle_plural)
		end

feature -- Constants

	Bottle_singular: STRING is "bottle"

	Bottle_plural: STRING is
			--
		once
			create Result.make_from_string (Bottle_singular)
			Result.append_character ('s')
		end

end -- class BOTTLE_STATUS_CLAUSE
