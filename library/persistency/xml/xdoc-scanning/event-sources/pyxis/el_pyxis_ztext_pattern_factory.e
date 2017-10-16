note
	description: "Summary description for {EL_PYXIS_PATTERN_FACTORY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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