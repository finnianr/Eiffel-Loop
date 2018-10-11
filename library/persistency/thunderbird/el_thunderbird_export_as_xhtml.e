note
	description: "Export contents of Thunderbird email folder as XHTML files"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-27 13:28:04 GMT (Thursday 27th September 2018)"
	revision: "4"

class
	EL_THUNDERBIRD_EXPORT_AS_XHTML

inherit
	EL_THUNDERBIRD_FOLDER_EXPORTER [EL_XHTML_WRITER]

create
	make

feature {NONE} -- Implementation

	on_email_end
		do
			extend_html (XML.header (1.0, "UTF-8"))
			do_with_lines (agent find_end_tag, raw_html_lines)
		end

feature {NONE} -- Constants

	End_tag_name: ZSTRING
		once
			Result := XML.closed_tag ("html")
		end

	Head_tag_close: ZSTRING
		once
			Result := XML.closed_tag ("head")
		end

	Related_file_extensions: ARRAY [ZSTRING]
		once
			Result := << "xhtml" >>
		end
end
