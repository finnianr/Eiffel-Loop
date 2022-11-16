note
	description: "Open office"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_OPEN_OFFICE

feature {NONE} -- Constants

	Office_namespace_url: ZSTRING
		once
			Result := "urn:oasis:names:tc:opendocument:xmlns:office:1.0"
		end

	Open_document_spreadsheet: ZSTRING
		once
			Result := "application/vnd.oasis.opendocument.spreadsheet"
		end
end