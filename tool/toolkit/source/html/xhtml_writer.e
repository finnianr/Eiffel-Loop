note
	description: "Summary description for {XHTML_WRITER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 14:27:25 GMT (Sunday 20th December 2015)"
	revision: "7"

class
	XHTML_WRITER

inherit
	HTML_WRITER
		redefine
			make, image_tag_text
		end

create
	make

feature {NONE} -- Initialization

	make (a_source_text: ZSTRING; output_path: EL_FILE_PATH; a_date_stamp: like date_stamp)
		do
			Precursor (a_source_text, output_path, a_date_stamp)
			set_utf_encoding (8)
		end

feature {NONE} -- Patterns

	delimiting_pattern: like one_of
			--
		do
			Result := one_of (<<
				charset_pattern,
				trailing_line_break,
				empty_tag_set,
				string_literal ("<br>") |to| agent replace (?, XML_line_break),
				preformat_end_tag,
				anchor_element_tag,
				image_element_tag
			>>)
		end

	charset_pattern: like all_of
		do
			Result := all_of (<<
				string_literal ("charset=ISO-8859-"), digit #occurs (1 |..| 2), string_literal ("%">")
			>>) |to| agent on_character_set
		end

feature {NONE} -- Event handling

	on_character_set (text: EL_STRING_VIEW)
		do
			put_string ("charset=UTF-8%"/>")
		end

feature {NONE} -- Implementation

	image_tag_text (match_text: EL_STRING_VIEW): ZSTRING
		do
			Result := Precursor (match_text)
			Result.insert_character ('/', Result.count - 1)
		ensure then
			tag_is_empty_element: Result.substring (Result.count - 1, Result.count).same_string ("/>")
		end

feature {NONE} -- Constants

	XML_line_break: ZSTRING
		once
			Result := "<br/>"
		end

end
