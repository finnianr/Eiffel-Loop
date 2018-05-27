note
	description: "Shared document types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "6"

class
	EL_SHARED_DOCUMENT_TYPES

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
