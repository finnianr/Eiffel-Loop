note
	description: "Export contents of Thunderbird email folder as XHTML document files"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-15 15:07:56 GMT (Saturday 15th January 2022)"
	revision: "8"

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
			html_doc.prepend (XML.header (1.0, "UTF-8") + s.character_string ('%N'))
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