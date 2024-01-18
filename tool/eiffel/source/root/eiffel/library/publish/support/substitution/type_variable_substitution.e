note
	description: "[
		${SOURCE_LINK_SUBSTITUTION} with new style of abbreviated source link format as
		shown at start of line.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-18 19:02:56 GMT (Thursday 18th January 2024)"
	revision: "2"

class
	TYPE_VARIABLE_SUBSTITUTION

inherit
	SOURCE_LINK_SUBSTITUTION
		redefine
			make_hyperlink, substitute_html, expand_as_source_link
		end

	EL_SET [CHARACTER_8]
		rename
			has as eiffel_type_character_set
		end

create
	make, make_preformatted

feature {NONE} -- Initialization

	make_hyperlink (a_delimiter_start: ZSTRING)
		do
			make_substitution (Dollor_left_brace, char ('}'), Empty_string, Empty_string)
		end

feature -- Basic operations

	substitute_html (html_string: ZSTRING)
		do
			html_string.edit (delimiter_start, delimiter_end, agent expand_as_source_link)
		end

feature {NONE} -- Implementation

	eiffel_type_character_set (c: CHARACTER_8): BOOLEAN
		do
			inspect c
				when 'A' .. 'Z', '0' .. '9', '_', ' ', '[', ']' then
					Result := True
			else
				Result := False
			end
		end

	expand_as_source_link (start_index, end_index: INTEGER; substring: ZSTRING)
		local
			link_text: ZSTRING
		do
			link_text := substring.substring (start_index, end_index)
			link_text.adjust
			if link_text.has_only_8 (Current) then -- in `eiffel_type_character_set'
				substring.share (new_expanded_link (Source_variable, link_text))
			end
		end

end