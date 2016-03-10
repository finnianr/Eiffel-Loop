note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "3"

class
	EL_OLD_XML_HTML_PATTERN_FACTORY

obsolete
	"Experimental"

inherit
	EL_OLD_XML_PATTERN_FACTORY

feature {NONE} -- Parsing actions

	comment_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			-- Void return value means do nothing
		do
		end

	tag_name_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			-- Void return value means do nothing
		do
		end

	closing_tag_name_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			-- Void return value means do nothing
		do
		end

end -- class EL_XML_HTML_TEXTUAL_PATTERNS

