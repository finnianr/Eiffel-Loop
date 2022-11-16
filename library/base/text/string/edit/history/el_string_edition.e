note
	description: "String edition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_STRING_EDITION

create
	make

feature {NONE} -- Initialization

	make (a_index: INTEGER_8; a_operands: TUPLE)
		do
			index := a_index
			operands := a_operands
		end

feature -- Access

	index: INTEGER_8

	operands: TUPLE

feature -- Basic operations

	apply (procedures: ARRAY [PROCEDURE])
		require
			valid_index: procedures.valid_index (index)
		do
			procedures.item (index).call (operands)
		end

feature -- Edition indices

	insert_character: INTEGER_8 = 1

	insert_string: INTEGER_8 = 2

	remove_character: INTEGER_8 = 3

	remove_substring: INTEGER_8 = 4

	replace_character: INTEGER_8 = 5

	replace_substring: INTEGER_8 = 6

	set_string, upper: INTEGER_8 = 7

end