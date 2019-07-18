note
	description: "Shared document types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:25:41 GMT (Monday 1st July 2019)"
	revision: "8"

deferred class
	EL_SHARED_DOCUMENT_TYPES

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Doc_type_html_utf_8: EL_DOC_TYPE
		once
			create Result.make_utf_8 ("html")
		end

	Doc_type_plain_latin_1: EL_DOC_TYPE
		once
			create Result.make_latin_1 ("plain")
		end

	Doc_type_plain_utf_8: EL_DOC_TYPE
		once
			create Result.make_utf_8 ("plain")
		end

	Doc_type_xml_utf_8: EL_DOC_TYPE
		once
			create Result.make_utf_8 ("xml")
		end

end
