note
	description: "Shared document types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-07 9:58:00 GMT (Thursday 7th May 2020)"
	revision: "9"

deferred class
	EL_SHARED_DOCUMENT_TYPES

inherit
	EL_ENCODING_CONSTANTS

feature {NONE} -- Constants

	Doc_type_html_utf_8: EL_DOC_TYPE
		once
			create Result.make ("html", Utf_8)
		end

	Doc_type_plain_latin_1: EL_DOC_TYPE
		once
			create Result.make ("plain", Latin_1)
		end

	Doc_type_plain_utf_8: EL_DOC_TYPE
		once
			create Result.make ("plain", Utf_8)
		end

	Doc_type_xml_utf_8: EL_DOC_TYPE
		once
			create Result.make ("xml", Utf_8)
		end

end
