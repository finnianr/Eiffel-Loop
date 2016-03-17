note
	description: "Summary description for {EL_OPEN_OFFICE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 12:38:45 GMT (Wednesday 16th December 2015)"
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
