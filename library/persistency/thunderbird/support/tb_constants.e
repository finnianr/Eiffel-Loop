note
	description: "Thunderbird constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-14 15:39:07 GMT (Sunday 14th April 2024)"
	revision: "13"

deferred class
	TB_CONSTANTS

inherit
	EL_ANY_SHARED

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

	intervals (line, search_string: ZSTRING): like Occurrence_intervals
		do
			Result := Occurrence_intervals
			Result.fill_by_string_general (line, search_string, 0)
		end

feature {NONE} -- Tag Strings

	Anchor_template: ZSTRING
		once
			Result := "[
				<a id="#">#</a>
			]"
		end

	Attribute_start: TUPLE [alt, href, src, title: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "[
				alt=",href=",src=",title="
			]")
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

	Tag_start: TUPLE [anchor, body, image: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "<a, <body, <img")
		end

feature {NONE} -- HTML tags

	List_tags: ARRAY [XML_TAG]
		once
			Result := << Tag.ordered_list, Tag.unordered_list >>
		end

	Paragraph: XML_TAG
		once
			Result := XML.tag ("p")
		end

	Tag: TUPLE [break, body, html, ordered_list, unordered_list: XML_TAG]
		once
			create Result
			Result.break := "br"
			Result.body := "body"
			Result.html := "html"
			Result.ordered_list := "ol"
			Result.unordered_list := "ul"
		end

	Text_tags: ARRAYED_LIST [XML_TAG]
		once
			Result := XML.numbered_tag_list ("h", Heading_levels.lower, Heading_levels.upper) + Paragraph
			Result.append (XML.tag_list ("li, ol"))
		end

feature {NONE} -- Constants

	Occurrence_intervals: EL_OCCURRENCE_INTERVALS
		once
			create Result.make_empty
		end

	Heading_levels: INTEGER_INTERVAL
		once
			Result := 1 |..| 5
		end

end