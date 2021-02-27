note
	description: "Markdown renderer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-27 18:41:02 GMT (Saturday 27th February 2021)"
	revision: "9"

class
	MARKDOWN_RENDERER

inherit
	ANY

	EL_MODULE_XML

	EL_ZSTRING_CONSTANTS

feature -- Access

	as_html (markdown: ZSTRING): ZSTRING
		do
			Result := XML.escaped (markdown)
			across Escaped_square_brackets as bracket loop
				Result.replace_substring_all (bracket.key, bracket.item)
			end
			Markup_substitutions.do_all (agent {MARKUP_SUBSTITUTION}.substitute_html (Result, agent new_expanded_link))
		end

feature {NONE} -- Factory

	new_expanded_link (path, text: ZSTRING; is_source_link: BOOLEAN): ZSTRING
		do
			Result := A_href_template #$ [path, text]
		end

	new_substitution (delimiter_start, delimiter_end, markup_open, markup_close: STRING): MARKUP_SUBSTITUTION
		do
			create Result.make (delimiter_start, delimiter_end, markup_open, markup_close)
		end

	new_hyperlink_substitution (delimiter_start: STRING): MARKUP_SUBSTITUTION
		do
			create Result.make_hyperlink (delimiter_start)
		end

	new_source_substitution: MARKUP_SUBSTITUTION
		do
			create Result.make_source_hyperlink
		end

feature {NONE} -- Constants

	A_href_template: ZSTRING
			-- contains to '%S' markers
		once
			Result := "[
				<a href="#" target="_blank">#</a>
			]"
		end

	Escaped_square_brackets: EL_ZSTRING_HASH_TABLE [ZSTRING]
		once
			create Result.make_equal (3)
			Result ["\["] := "&lsqb;"
			Result ["\]"] := "&rsqb;"
		end

	Markup_substitutions: ARRAYED_LIST [MARKUP_SUBSTITUTION]
		once
			create Result.make_from_array (<<
				new_hyperlink_substitution ("[http://"),
				new_hyperlink_substitution ("[https://"),
				new_hyperlink_substitution ("[./"),

				new_substitution ("[li]", "[/li]", "<li>", "</li>"),

				-- Ordered list item with span to allow bold numbering using CSS
				new_substitution ("[oli]", "[/oli]", "<li><span>", "</span></li>"),

				new_substitution ("`", "&apos;", "<em id=%"code%">", "</em>"),
				new_substitution ("**", "**", "<b>", "</b>"),
				new_substitution ("&apos;&apos;", "&apos;&apos;", "<i>", "</i>")
			>>)
		end

end