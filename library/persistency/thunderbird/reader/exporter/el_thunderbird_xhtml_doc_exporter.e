note
	description: "Export contents of Thunderbird email folder as XHTML document files"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-21 15:21:12 GMT (Friday 21st January 2022)"
	revision: "10"

class
	EL_THUNDERBIRD_XHTML_DOC_EXPORTER

inherit
	EL_THUNDERBIRD_XHTML_EXPORTER
		redefine
			edit, Unclosed_tags
		end

create
	make

feature {NONE} -- Implementation

	edit (html_doc: ZSTRING)
		local
			s: EL_ZSTRING_ROUTINES
		do
			Precursor (html_doc)
			html_doc.prepend_string_general (XML.header (1.0, "UTF-8") + s.character_string ('%N'))
			html_doc.edit ("content=%"text/html;", "%"", agent edit_content_type)
		end

	edit_content_type (start_index, end_index: INTEGER; target: ZSTRING)
		local
			type: ZSTRING; index: INTEGER
		do
			type := target.substring (start_index, end_index)
			type.left_adjust
			type.prepend_character (' ')
			index := type.index_of ('=', 1)
			if index > 0 then
				type.replace_substring_general ("UTF-8", index + 1, type.count)
			end
			target.replace_substring (type, start_index, end_index)
		end

feature {NONE} -- Constants

	Related_file_extensions: EL_ZSTRING_LIST
		once
			Result := "xhtml"
		end

	Unclosed_tags: EL_ZSTRING_LIST
		once
			Result := "<br, <meta"
		end
end