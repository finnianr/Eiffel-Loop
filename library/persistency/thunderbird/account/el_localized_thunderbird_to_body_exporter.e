note
	description: "Localized thunderbird to body exporter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 11:23:09 GMT (Wednesday 17th October 2018)"
	revision: "3"

class
	EL_LOCALIZED_THUNDERBIRD_TO_BODY_EXPORTER

inherit
	EL_LOCALIZED_THUNDERBIRD_ACCOUNT_READER

create
	make_from_file

feature {NONE} -- Implementation

--	new_reader: EL_THUNDERBIRD_EXPORT_AS_XHTML_BODY
	new_reader: EL_THUNDERBIRD_FOLDER_TO_XHTML_BODY
		do
			create Result.make (Current)
		end

end
