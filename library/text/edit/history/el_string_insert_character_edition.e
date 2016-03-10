note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_STRING_INSERT_CHARACTER_EDITION

inherit
	EL_STRING_EDITION
		rename
			make as make_edition
		end

create
	make

feature {NONE} -- Initialization

	make (a_caret_position, a_start_index: INTEGER; a_insertion: like insertion)
		do
			make_edition (a_caret_position.to_natural_16, a_start_index.to_natural_16)
			insertion := a_insertion
		end

feature -- Basic operations

	apply (target: EL_ASTRING)
		do
			target.insert_character (insertion, start_index)
		ensure then
			inserted_into_target:  target [start_index] ~ insertion
		end

feature {NONE} -- Implementation

	insertion: CHARACTER

end
