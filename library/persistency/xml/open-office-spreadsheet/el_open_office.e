note
	description: "Summary description for {EL_OPEN_OFFICE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "4"

class
	EL_OPEN_OFFICE

feature {NONE} -- Constants

	Office_namespace_url: ASTRING
		once
			Result := "urn:oasis:names:tc:opendocument:xmlns:office:1.0"
		end

	Open_document_spreadsheet: ASTRING
		once
			Result := "application/vnd.oasis.opendocument.spreadsheet"
		end
end
