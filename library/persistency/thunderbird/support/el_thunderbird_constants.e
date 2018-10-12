note
	description: "Thunderbird constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-12 16:42:23 GMT (Friday 12th October 2018)"
	revision: "1"

class
	EL_THUNDERBIRD_CONSTANTS

inherit
	EL_MODULE_XML

feature {NONE} -- Constants

	Body_tag: ZSTRING
		once
			Result := "<body"
		end

	Body_tag_close: ZSTRING
		once
			Result := XML.closed_tag ("body")
		end

	Html_tag: TUPLE [open, close: ZSTRING]
		once
			Result := XML.tag ("html")
		end

end
