note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_HTML_PATTERN_FACTORY

inherit
	EL_XML_HTML_PATTERN_FACTORY

feature {NONE} -- HTML element patterns
	
	element_attribute: EL_MATCH_ALL_IN_LIST_TP
			-- 
		do
			Result := all_of ( <<  
				white_space,
				c_identifier,
				maybe_white_space,
				character_literal ('='),
				maybe_white_space,
				attribute_quoted_string_value (Void)
			>> )
		end
	
	html_literal_tag_close (tag_name: STRING): EL_MATCH_ALL_IN_LIST_TP
			-- 
		do
			Result := html_tag_close (case_insensitive_tag_name (tag_name))
		end

	html_tag_close (tag_pattern: EL_MATCH_ALL_IN_LIST_TP): EL_MATCH_ALL_IN_LIST_TP
			-- 
		do
			Result := all_of ( <<
				string_literal ("</"),
				tag_pattern,
				character_literal ('>')
			>> )
			Result.set_name ("html_tag_close")
			Result.set_debug_to_depth (1)
		end
	
	case_insensitive_tag_name (tag_name: STRING): EL_FIRST_MATCH_IN_LIST_TP
			-- 
		local
			tag_name_lower, tag_name_upper: STRING
		do
			tag_name.to_lower
			tag_name_lower := tag_name.out
			tag_name.to_upper
			tag_name_upper := tag_name.out
			Result := one_of ( <<
								string_literal (tag_name_lower),
								string_literal (tag_name_upper)
							>> )
		end
	
	html_literal_tag_open (tag_name: STRING): EL_MATCH_ALL_IN_LIST_TP
			-- 
		do
			Result := html_tag_open (case_insensitive_tag_name (tag_name))
			Result.set_name ("html_literal_tag_open")
			Result.set_debug_to_depth (1)
		end
		
	
	html_tag_open (tag_pattern: EL_MATCH_ALL_IN_LIST_TP): EL_MATCH_ALL_IN_LIST_TP
			-- <tag a1="v1" a-n="v-n">
		local
			attributes_and_closing_bracket: EL_MATCH_TP1_ON_CONDITION_TP2_MATCH_TP
		do
			attributes_and_closing_bracket := while_not_pattern_1_repeat_pattern_2 (
				all_of ( <<
					maybe_white_space,
					character_literal ('>')					
				>> ),
				element_attribute
			)
--			attributes_and_closing_bracket.set_name ("attributes_and_closing_bracket")
			create Result.make ( <<  
				character_literal ('<'),
				tag_pattern,
				attributes_and_closing_bracket
			>>)
		end

	html_text: EL_MATCH_ONE_OR_MORE_TIMES_TP
			-- 
		do
			Result := one_or_more (
				one_of (<<
					not character_literal ('<'),
					string_literal ("<<") -- this is a literal character in HTML
				>>)
			)
			Result.set_name ("html_text")
			Result.set_debug_to_depth (1)
		end

end -- class EL_HTML_PATTERNS
                                                                                                                                                                                                                  
