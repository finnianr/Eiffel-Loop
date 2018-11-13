note
	description: "Thunderbird constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-08 13:00:02 GMT (Thursday 8th November 2018)"
	revision: "3"

class
	EL_THUNDERBIRD_CONSTANTS

inherit
	EL_MODULE_XML

feature {NONE} -- Constants

	Anchor_template: ZSTRING
		once
			Result := "[
				<a id="#">#</a>
			]"
		end

	Body_tag: ZSTRING
		once
			Result := "<body"
		end

	Body_tag_close: ZSTRING
		once
			Result := XML.closed_tag ("body")
		end

	Empty_tag_close: ZSTRING
		once
			Result := "/>"
		end

	Html_tag: TUPLE [open, close: ZSTRING]
		once
			Result := XML.tag ("html")
		end

	Image_tag: ZSTRING
		once
			Result := "<img"
		end

	New_line_indent: ZSTRING
		once
			Result := "%N    "
		end

	Paragraph: TUPLE [open, close: ZSTRING]
		once
			Result := XML.tag ("p")
		end

end
