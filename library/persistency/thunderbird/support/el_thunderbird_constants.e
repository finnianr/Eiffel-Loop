note
	description: "Thunderbird constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-05 11:53:48 GMT (Tuesday 5th January 2021)"
	revision: "8"

class
	EL_THUNDERBIRD_CONSTANTS

inherit
	ANY
	
	EL_MODULE_XML

	EL_MODULE_TUPLE

	EL_ZSTRING_CONSTANTS

feature {NONE} -- Implementation

	header_tag (level: INTEGER): like Text_tags.item
		require
			valid_level: Heading_levels.has (level)
		do
			Result := Text_tags [level]
		end

feature {NONE} -- Strings

	Anchor_template: ZSTRING
		once
			Result := "[
				<a id="#">#</a>
			]"
		end

	Empty_tag_close: ZSTRING
		once
			Result := "/>"
		end

	New_line_indent: ZSTRING
		once
			Result := "%N    "
		end

	Tag_close_start: ZSTRING
		once
			Result := "</"
		end


feature {NONE} -- Constants

	Attribute_start: TUPLE [alt, href, src, title: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "[
				alt=",href=",src=",title="
			]")
		end

	Heading_levels: INTEGER_INTERVAL
		once
			Result := 1 |..| 5
		end

	List_tags: ARRAY [EL_XML_TAG]
		once
			Result := << Tag.ordered_list, Tag.unordered_list >>
		end

	Paragraph: EL_XML_TAG
		once
			Result := XML.tag ("p")
		end

	Tag: TUPLE [break, body, html, ordered_list, unordered_list: EL_XML_TAG]
		once
			create Result
			Result.break := "br"
			Result.body := "body"
			Result.html := "html"
			Result.ordered_list := "ol"
			Result.unordered_list := "ul"
		end

	Tag_start: TUPLE [anchor, body, image: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "<a, <body, <img")
		end

	Text_tags: ARRAYED_LIST [EL_XML_TAG]
		once
			Result := XML.numbered_tag_list ("h", Heading_levels.lower, Heading_levels.upper) + Paragraph
			Result.append (XML.tag_list ("li, ol"))
		end

end