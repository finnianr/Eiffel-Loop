note
	description: "Parser keyword and symbol tokens"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-30 12:27:29 GMT (Wednesday 30th April 2025)"
	revision: "9"

class
	EVC_TOKEN_ENUM

inherit
	EL_ENUMERATION_NATURAL_32
		rename
			new_table_text as Empty_text,
			name_translater as default_translater
		redefine
			initialize
		end

create
	make

feature {NONE} -- Initialization

	initialize
		do
			loop_keywords := << keyword_across, keyword_foreach >>
			literals := << literal_real, literal_integer, literal_string >>
		end

feature -- Access

	loop_keywords: ARRAY [NATURAL]

	literals: ARRAY [NATURAL]

feature -- Keywords

	keyword_across: NATURAL

	keyword_and: NATURAL

	keyword_as: NATURAL

	keyword_else: NATURAL

	keyword_end: NATURAL

	keyword_evaluate: NATURAL

	keyword_foreach: NATURAL

	keyword_if: NATURAL

	keyword_in: NATURAL

	keyword_include: NATURAL

	keyword_loop: NATURAL

	keyword_not: NATURAL

	keyword_or: NATURAL

	keyword_then: NATURAL

feature -- Bracket tokens

	Left_bracket: NATURAL

	Right_bracket: NATURAL

feature -- Operator tokens

	operator_dot: NATURAL

	operator_equal_to: NATURAL

	operator_greater_than: NATURAL

	operator_less_than: NATURAL

	operator_not_equal_to: NATURAL

feature -- Literal value tokens

	literal_real: NATURAL

	literal_integer: NATURAL

	literal_string: NATURAL

feature -- Other tokens

	at_sign: NATURAL

	comma_sign: NATURAL

	double_dollor_sign: NATURAL

	free_text: NATURAL

	template_name_identifier: NATURAL

	unqualified_name: NATURAL

	white_text: NATURAL

end