note
	description: "Export contents of Thunderbird email folder as XHTML document files"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-08 18:10:45 GMT (Friday 8th January 2021)"
	revision: "7"

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

	Related_file_extensions: ARRAY [ZSTRING]
		once
			Result := << "xhtml" >>
		end

	Unclosed_tags: ARRAY [ZSTRING]
		once
			Result := << "<br", "<meta" >>
		end
end