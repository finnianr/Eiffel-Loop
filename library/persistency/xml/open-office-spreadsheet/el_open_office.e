note
	description: "Summary description for {EL_OPEN_OFFICE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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