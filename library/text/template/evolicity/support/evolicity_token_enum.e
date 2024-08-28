note
	description: "Parser keyword and symbol tokens"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-28 6:36:34 GMT (Wednesday 28th August 2024)"
	revision: "4"

class
	EVOLICITY_TOKEN_ENUM

inherit
	EL_ENUMERATION_NATURAL_32
		rename
			description_table as No_descriptions,
			foreign_naming as eiffel_naming
		redefine
			initialize_fields
		end

create
	make

feature {NONE} -- Initialization

	initialize_fields
		do
			Precursor
			loop_keywords := << keyword_across, keyword_foreach >>
		end

feature -- Access

	loop_keywords: ARRAY [NATURAL]

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

feature -- Other tokens

	Comma_sign: NATURAL

	Double_constant: NATURAL

	Double_dollor_sign: NATURAL

	Free_text: NATURAL

	Integer_64_constant: NATURAL

	Quoted_string: NATURAL

	Template_name_identifier: NATURAL

	Unqualified_name: NATURAL

	White_text: NATURAL

end