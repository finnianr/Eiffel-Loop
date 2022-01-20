note
	description: "Thunderbird www exporter app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-20 16:20:30 GMT (Thursday 20th January 2022)"
	revision: "22"

class
	THUNDERBIRD_WWW_EXPORTER_APP

inherit
	THUNDERBIRD_ACCOUNT_READER_APP [EL_THUNDERBIRD_WWW_EXPORTER]
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