note
	description: "Thunderbird www exporter app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-10 15:32:11 GMT (Monday 10th January 2022)"
	revision: "20"

class
	THUNDERBIRD_WWW_EXPORTER_APP

inherit
	THUNDERBIRD_ACCOUNT_READER_APP [THUNDERBIRD_WWW_EXPORTER]
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

	Description: STRING = "Export HTML content from www directory under Thunderbird account"

end