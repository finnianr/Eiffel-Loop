note
	description: "Thunderbird www exporter app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-23 14:21:33 GMT (Monday 23rd January 2023)"
	revision: "24"

class
	THUNDERBIRD_WWW_EXPORTER_APP

inherit
	THUNDERBIRD_ACCOUNT_READER_APP [TB_WWW_XHTML_CONTENT_EXPORTER]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make_from_file ("")
		end

feature {NONE} -- Constants

	Option_name: STRING = "export_www"

end
