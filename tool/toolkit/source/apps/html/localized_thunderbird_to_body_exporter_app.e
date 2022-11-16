note
	description: "[
		Export folders of Thunderbird HTML as XHTML bodies and recreating the folder structure.
		
		See class [$source EL_ML_THUNDERBIRD_ACCOUNT_XHTML_BODY_EXPORTER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "23"

class
	LOCALIZED_THUNDERBIRD_TO_BODY_EXPORTER_APP

inherit
	THUNDERBIRD_ACCOUNT_READER_APP [EL_ML_THUNDERBIRD_ACCOUNT_XHTML_BODY_EXPORTER]
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

	Option_name: STRING = "export_thunderbird_to_body"

end