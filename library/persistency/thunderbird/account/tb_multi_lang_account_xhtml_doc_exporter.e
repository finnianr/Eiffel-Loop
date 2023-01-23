note
	description: "Localized Thunderbird to XHTML exporter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-23 13:21:19 GMT (Monday 23rd January 2023)"
	revision: "5"

class
	TB_MULTI_LANG_ACCOUNT_XHTML_DOC_EXPORTER

inherit
	TB_MULTI_LANG_ACCOUNT_READER

create
	make_from_file

feature -- Constants

	Description: STRING = "Export multi-lingual HTML content from Thunderbird as XHTML files"

feature {NONE} -- Implementation

	new_reader: TB_XHTML_DOCUMENT_EXPORTER
		do
			create Result.make (Current)
		end

end

