note
	description: "Multi-lingual (ML) Thunderbird account XHTML body exporter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-23 14:44:28 GMT (Monday 23rd January 2023)"
	revision: "7"

class
	TB_MULTI_LANG_ACCOUNT_XHTML_BODY_EXPORTER

inherit
	TB_MULTI_LANG_ACCOUNT_READER

create
	make_from_file

feature -- Constants

	Description: STRING = "[
		Export multi-lingual HTML body content from Thunderbird as files with .body extension
	]"

feature {NONE} -- Implementation

	new_reader: TB_XHTML_BODY_EXPORTER
		do
			create Result.make (Current)
		end

end


