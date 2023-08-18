note
	description: "Export contents of Thunderbird email folder as XHTML document files"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 16:17:08 GMT (Thursday 17th August 2023)"
	revision: "13"

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
		do
			Precursor (html_doc)
			html_doc.prepend_string_general (XML.header (1.0, "UTF-8") + New_line * 1)
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