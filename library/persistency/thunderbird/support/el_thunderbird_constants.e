note
	description: "Thunderbird constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-17 11:51:56 GMT (Saturday 17th November 2018)"
	revision: "4"

class
	EL_THUNDERBIRD_CONSTANTS

inherit
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

	paragraph: like Text_tags.item
		do
			Result := Text_tags.last
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
			create Result.make (Heading_levels.upper + 1)
			across Heading_levels as level loop
				Result.extend (XML.tag (character_string ('h') + level.item.out))
			end
			Result.extend (XML.tag ("p"))
		end

end
