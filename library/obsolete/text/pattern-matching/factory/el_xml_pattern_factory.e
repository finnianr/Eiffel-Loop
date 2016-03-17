note
	description: "Summary description for {EL_XML_PATTERN_FACTORY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-14 15:15:25 GMT (Monday 14th December 2015)"
	revision: "5"

class
	EL_XML_PATTERN_FACTORY

inherit
	EL_TEXTUAL_PATTERN_FACTORY

feature -- Access

	comment (comment_action: like Default_match_action): like all_of
			--
		local
			comment_text: like while_not_pattern_1_repeat_pattern_2
		do
			comment_text := while_not_pattern_1_repeat_pattern_2 (string_literal ("-->"), any_character )
			comment_text.set_action_on_combined_repeated_match (comment_action)
			Result := all_of ( << string_literal ("<!--"), comment_text >> )
		end

	xml_identifier: like all_of
			--
		do
			Result := all_of (<<
				one_of_characters (<< letter, character_literal ('_') >>),
				zero_or_more (one_of_characters (<< alpha_numeric, one_character_from (":_.-") >>))
			>>)
		end

	xml_attribute (name_action, value_action: like Default_match_action): like all_of
		local
			attribute_name: like xml_identifier
			attribute_value: like while_not_pattern_1_repeat_pattern_2
		do
			attribute_name := xml_identifier
			if name_action /= Default_match_action then
				attribute_name.set_action_on_match_begin (name_action)
			end
			attribute_value := while_not_pattern_1_repeat_pattern_2 (character_literal ('"'), any_character)
			if value_action /= Default_match_action then
				attribute_value.set_action_on_combined_repeated_match (value_action)
			end
			Result := all_of (<<
				attribute_name,
				maybe_non_breaking_white_space,
				character_literal ('='),
				maybe_non_breaking_white_space,
				character_literal ('"'),
				attribute_value
			>>)
		end

end

