note
	description: "Localized Thunderbird to XHTML exporter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-20 14:49:13 GMT (Thursday 20th January 2022)"
	revision: "3"

class
	EL_ML_THUNDERBIRD_ACCOUNT_XHTML_DOC_EXPORTER

inherit
	EL_ML_THUNDERBIRD_ACCOUNT_READER

create
	make_from_file

feature -- Constants

	Description: STRING = "Export multi-lingual HTML content from Thunderbird as XHTML files"

feature {NONE} -- Implementation

	new_reader: EL_THUNDERBIRD_XHTML_DOC_EXPORTER
		do
			create Result.make (Current)
		end

end