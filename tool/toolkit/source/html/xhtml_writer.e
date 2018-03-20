note
	description: "Summary description for {XHTML_WRITER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-14 11:58:06 GMT (Wednesday 14th March 2018)"
	revision: "4"

class
	XHTML_WRITER

inherit
	HTML_WRITER
		redefine
			make
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
				preformat_end_tag,
				anchor_element_tag,
				image_element_tag
			>>)
		end

	charset_pattern: like all_of
		do
			Result := all_of (<<
				string_literal ("charset="),
				one_of (<< iso_charset, windows_charset >>),
				character_literal ('"')
			>>) |to| agent on_character_set
		end

	iso_charset: like all_of
		do
			Result := all_of (<<
				one_of_case_literal ("iso-8859"), hyphen, digit #occurs (1 |..| 2)
			>>)
		end

	windows_charset: like all_of
		do
			Result := all_of (<<
				one_of_case_literal ("windows"), hyphen, digit #occurs (4 |..| 4)
			>>)
		end

	hyphen: like character_literal
		do
			Result := character_literal ('-')
		end

feature {NONE} -- Event handling

	on_character_set (text: EL_STRING_VIEW)
		do
			put_string ("charset=UTF-8%"")
		end

end
