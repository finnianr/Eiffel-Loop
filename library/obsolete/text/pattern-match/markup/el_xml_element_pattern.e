note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-14 19:00:16 GMT (Monday 14th December 2015)"
	revision: "1"

class
	EL_XML_ELEMENT_PATTERN

inherit
	EL_FIRST_MATCH_IN_LIST_TP
		rename
			make as make_pattern
		end

	EL_XML_PATTERN_FACTORY
		undefine
			default_create, Default_match_action
		end

create
	make

feature {NONE} -- Initialization

	make (
		tag_name: STRING;
		attribute_patterns: EL_MATCH_ZERO_OR_MORE_TIMES_TP
		nested_elements: ARRAY [EL_MATCH_ALL_IN_LIST_TP]
	)
			--
		local
			nested_element_alternatives: EL_FIRST_MATCH_IN_LIST_TP
		do
			create nested_element_alternatives
			nested_element_alternatives.extend (white_space)
			if nested_elements /= Void then
				nested_element_alternatives.append (
					create {ARRAYED_LIST [EL_TEXTUAL_PATTERN]}.make_from_array (nested_elements)
				)
			end
			nested_element_alternatives.extend (comment (Default_match_action))

			make_pattern ( <<
				-- 	<tag a1="value"> some stuff </tag>
				all_of ( <<
--					named_opening_element (tag_name,">", attribute_patterns),
--					zero_or_more ( nested_element_alternatives),
--					named_closing_element (tag_name)
				>> ),

				-- 	<tag a1="value"/>
				create {EL_XML_EMPTY_ELEMENT_PATTERN}.make (tag_name, attribute_patterns)
			>> )
		end

end