note
	description: "Markdown renderer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-01 11:04:02 GMT (Monday 1st April 2024)"
	revision: "15"

class
	MARKDOWN_RENDERER

inherit
	ANY
		redefine
			default_create
		end

	EL_MODULE_XML

	EL_ZSTRING_CONSTANTS

	PUBLISHER_CONSTANTS

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			relative_page_dir := "."
		end

feature -- Access

	as_html (markdown: ZSTRING): ZSTRING
		do
			Result := XML.escaped (markdown)
			across Escaped_square_brackets as bracket loop
				Result.replace_substring_all (bracket.key, bracket.item)
			end
			across Markup_substitutions as list loop
				list.item.substitute_html (Result)
			end
			across Link_substitutions as list loop
				if list.item.has_link (Result) then
					list.item.set_relative_page_dir (relative_page_dir)
					list.item.substitute_html (Result)
				end
			end
		end

feature {NONE} -- Factory

	new_substitution (
		delimiter_start, delimiter_end, markup_open, markup_close: READABLE_STRING_GENERAL
	): MARKUP_SUBSTITUTION
		do
			create Result.make (delimiter_start, delimiter_end, markup_open, markup_close)
		end

	new_hyperlink_substitution (delimiter_start: READABLE_STRING_GENERAL): HYPERLINK_SUBSTITUTION
		do
			create Result.make (delimiter_start)
		end

	new_link_substitutions: EL_ARRAYED_LIST [HYPERLINK_SUBSTITUTION]
		do
			create Result.make (3)
			across << "[http://", "[https://", "[./" >> as list loop
				Result.extend (new_hyperlink_substitution (list.item))
			end
		end

feature {NONE} -- Internal attributes

	relative_page_dir: DIR_PATH
		-- class page relative to index page directory tree

feature {NONE} -- Constants

	Escaped_square_brackets: EL_ZSTRING_HASH_TABLE [ZSTRING]
		once
			create Result.make_equal (3)
			Result ["\["] := "&lsqb;"
			Result ["\]"] := "&rsqb;"
		end

	Link_substitutions: EL_ARRAYED_LIST [HYPERLINK_SUBSTITUTION]
		once
			Result := new_link_substitutions
		end

	Markup_substitutions: ARRAYED_LIST [MARKUP_SUBSTITUTION]
		once
			create Result.make_from_array (<<
				new_substitution (Tag.li, Tag.li_close, "<li>", "</li>"),

			-- Ordered list item with span to allow bold numbering using CSS
				new_substitution (Tag.oli, Tag.oli_close, "<li><span>", "</span></li>"),

				new_substitution ("`", "&apos;", "<em id=%"code%">", "</em>"),
				new_substitution ("**", "**", "<b>", "</b>"),
				new_substitution ("&apos;&apos;", "&apos;&apos;", "<i>", "</i>")
			>>)
		end

end