note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_OLD_XML_PATTERN_FACTORY

obsolete
	"Experimental"

inherit
	EL_XML_PATTERN_FACTORY

feature {NONE} -- XML element patterns

	attribute_list (attributes: ARRAY [EL_MATCH_ALL_IN_LIST_TP]): EL_MATCH_ZERO_OR_MORE_TIMES_TP
			--
		local
			attribute_alternatives: EL_FIRST_MATCH_IN_LIST_TP
		do
			create attribute_alternatives.make (attributes)
--			attribute_alternatives.put_front (white_space)
			Result := zero_or_more (attribute_alternatives)
		end

	named_closing_element (tag_name: STRING): EL_MATCH_ALL_IN_LIST_TP
			--
		local
			tag_pattern: EL_LITERAL_TEXTUAL_PATTERN
		do
			tag_pattern := string_literal (tag_name)
--			tag_pattern.set_action_on_match (closing_tag_name_action)

			Result := all_of ( <<
				string_literal ("</"),
				tag_pattern,
				character_literal ('>')
			>> )
		end

	named_opening_element (
		tag_name: STRING;
		termination_string: STRING;
		attributes: EL_MATCH_ZERO_OR_MORE_TIMES_TP
	): EL_MATCH_ALL_IN_LIST_TP
			-- <tag a1="v1" a-n="v-n">
		local
			tag_pattern: EL_LITERAL_TEXTUAL_PATTERN
		do
			tag_pattern := string_literal (tag_name)
--			tag_pattern.set_action_on_match (tag_name_action)

			create Result.make ( <<
				character_literal ('<'),
				tag_pattern
			>>)
			if attributes /= Void then
				Result.extend (attributes)
			end
			Result.extend (maybe_white_space)
			Result.extend (string_literal (termination_string) )
			Result.set_name ("named_opening_element (%"" + tag_name + "%")")
		end

end -- class XML_PATTERNS

