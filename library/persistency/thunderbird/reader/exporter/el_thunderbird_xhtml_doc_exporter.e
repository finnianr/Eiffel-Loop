note
	description: "Export contents of Thunderbird email folder as XHTML document files"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-19 9:45:31 GMT (Friday 19th October 2018)"
	revision: "6"

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
		do
			Precursor (html_doc)
			html_doc.prepend (XML.header (1.0, "UTF-8") + character_string ('%N'))
		end

feature {NONE} -- Constants

	Related_file_extensions: ARRAY [ZSTRING]
		once
			Result := << "xhtml" >>
		end

	Unclosed_tags: ARRAY [ZSTRING]
		once
			Result := << "<br", "<meta" >>
		end
end
