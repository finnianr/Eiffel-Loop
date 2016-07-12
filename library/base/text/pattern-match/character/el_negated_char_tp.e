note
	description: "Summary description for {EL_NEGATED_CHAR_TP2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 14:24:48 GMT (Sunday 20th December 2015)"
	revision: "5"

class
	EL_NEGATED_CHAR_TP

inherit
	EL_SINGLE_CHAR_TEXT_PATTERN
		undefine
			has_action
		end

	EL_NEGATED_TEXT_PATTERN
		undefine
			logical_not
		redefine
			Type_negated_pattern, actual_count
		end

create
	make

feature {NONE} -- Implementation

	Actual_count: INTEGER = 1

feature {NONE} -- Anchored type

	Type_negated_pattern: EL_SINGLE_CHAR_TEXT_PATTERN
		do
		end
end
