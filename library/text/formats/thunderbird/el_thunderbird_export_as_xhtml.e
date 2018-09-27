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
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (a_output_dir: EL_DIR_PATH)
			--
		do
			Precursor (a_output_dir)
			create html_lines.make (50)
		end

feature {NONE} -- State handlers

	on_html_tag (tag_value: ZSTRING)
		do
			extend_html (XML.header (1.0, "UTF-8"))
			extend_html (tag_value)
			state := agent find_end_tag
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
