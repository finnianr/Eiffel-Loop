note
	description: "Export contents of Thunderbird email folder as XHTML document files"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-23 13:22:20 GMT (Monday 23rd January 2023)"
	revision: "12"

class
	TB_XHTML_DOCUMENT_EXPORTER

inherit
	TB_XHTML_FOLDER_EXPORTER
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