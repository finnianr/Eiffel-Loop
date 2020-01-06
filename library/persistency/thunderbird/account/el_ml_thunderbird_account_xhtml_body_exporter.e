note
	description: "Multi-lingual (ML) Thunderbird account XHTML body exporter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-19 11:24:46 GMT (Friday 19th October 2018)"
	revision: "4"

class
	EL_ML_THUNDERBIRD_ACCOUNT_XHTML_BODY_EXPORTER

inherit
	EL_ML_THUNDERBIRD_ACCOUNT_READER

create
	make_from_file

feature {NONE} -- Implementation

	new_reader: EL_THUNDERBIRD_XHTML_BODY_EXPORTER
		do
			create Result.make (Current)
		end

end
