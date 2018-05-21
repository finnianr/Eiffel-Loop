note
	description: "Pyxis ztext pattern factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_PYXIS_ZTEXT_PATTERN_FACTORY

inherit
	EL_EIFFEL_TEXT_PATTERN_FACTORY

feature {NONE} -- Pattern definitions		

	double_quote_escape_sequence: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := one_of ( << string_literal ("\\"), string_literal ("\%"") >> )
		end

	single_quote_escape_sequence: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := one_of ( << string_literal ("\\"), string_literal ("\'") >> )
		end

	attribute_identifier: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				letter,
				zero_or_more (one_of (<< alphanumeric, one_character_from ("-_.") >>))
			>>)
		end

	xml_identifier: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				one_of (<< letter, character_literal ('_') >> ),
				zero_or_more (xml_identifier_character)
			>>)
		end

	xml_identifier_character: EL_FIRST_MATCHING_CHAR_IN_LIST_TP
		do
			Result := identifier_character
			Result.extend (character_literal ('-'))
		end

end