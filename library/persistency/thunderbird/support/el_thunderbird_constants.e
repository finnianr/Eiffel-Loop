note
	description: "Thunderbird constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-22 10:30:41 GMT (Monday 22nd October 2018)"
	revision: "2"

class
	EL_THUNDERBIRD_CONSTANTS

inherit
	EL_MODULE_XML

feature {NONE} -- Constants

	Anchor_template: ZSTRING
		once
			Result := "[
				<a id="#"/>
			]"
			Result.append (New_line_indent)
		end

	New_line_indent: ZSTRING
		once
			Result := "%N    "
		end

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
