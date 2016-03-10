note
	description: "Summary description for {EL_HTTP_CONTENT_TYPE_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-30 16:18:45 GMT (Saturday 30th January 2016)"
	revision: "7"

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
