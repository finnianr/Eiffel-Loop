note
	description: "Summary description for {EL_OPEN_OFFICE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:00 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_OPEN_OFFICE

feature {NONE} -- Constants

	Office_namespace_url: EL_ASTRING
		once
			Result := "urn:oasis:names:tc:opendocument:xmlns:office:1.0"
		end

	Open_document_spreadsheet: EL_ASTRING
		once
			Result := "application/vnd.oasis.opendocument.spreadsheet"
		end
end