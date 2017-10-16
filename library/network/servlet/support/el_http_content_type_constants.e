note
	description: "Summary description for {EL_HTTP_CONTENT_TYPE_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_HTTP_CONTENT_TYPE_CONSTANTS

feature {NONE} -- Constants

	Content_html_utf_8: EL_HTTP_CONTENT_TYPE
		once
			create Result.make_utf_8 ("html")
		end

	Content_plain_latin_1: EL_HTTP_CONTENT_TYPE
		once
			create Result.make_latin_1 ("plain")
		end

	Content_xml_utf_8: EL_HTTP_CONTENT_TYPE
		once
			create Result.make_utf_8 ("xml")
		end

end