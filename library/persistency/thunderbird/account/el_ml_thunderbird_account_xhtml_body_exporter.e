note
	description: "Multi-lingual (ML) Thunderbird account XHTML body exporter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_ML_THUNDERBIRD_ACCOUNT_XHTML_BODY_EXPORTER

inherit
	EL_ML_THUNDERBIRD_ACCOUNT_READER

create
	make_from_file

feature -- Constants

	Description: STRING = "[
		Export multi-lingual HTML body content from Thunderbird as files with .body extension
	]"

feature {NONE} -- Implementation

	new_reader: EL_THUNDERBIRD_XHTML_BODY_EXPORTER
		do
			create Result.make (Current)
		end

end