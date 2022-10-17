note
	description: "[
		A basic XHTML text renderer based on the [$source EV_RICH_TEXT] component with support for the following markup:
		
		* Any text between elements
		* Headings: `<h1>, <h2> ..' and so forth
		* Blockquotes: `<blockquote>'
		* Paragraphs: `<p>'
		* Ordered lists: `<ol><li>'
		* Unordered lists: `<ul><li>'
		* Pre-formatted text: `<pre>'
		* Anchor text highlighting (but not navigable): `<a>'
		* Bold text: `<b>'
		* Italic text: `<i>'
		* Line breaks: `<br/>'
		* Meta title info: `<title>'
	]"
	notes: "[
		**Hyperlinks**
		Any hyper-links in the markup are highlighted with the `link_text_color' but are not navigable in
		the text due to limitations of [$source EL_RICH_TEXT]. However they are accessible in `external_links'
		and can be made navigable using class [$source EL_HYPERLINK_AREA], perhaps in a split Window page
		contents area.
		
		**Building Contents**
		A page contents area can be created in a split window using the links accessible via
		`navigation_links'. 
		
		**Example of Use**
		See the help system in the [http://myching.software My Ching software].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-17 13:26:55 GMT (Monday 17th October 2022)"
	revision: "17"

class
	EL_HTML_TEXT

inherit
	EL_RICH_TEXT

	EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS
		rename
			build_from_file as build_from_xhtml_file
		undefine
			default_create, copy
		redefine
			make_default
		end

	EL_XML_PARSE_EVENT_TYPE
		undefine
			default_create, copy
		end

	EL_MODULE_COLOR

	EL_MODULE_TEXT
		rename
			Text as Text_font
		end

	EL_MODULE_SCREEN

	EL_MODULE_FILE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make (a_font: EL_FONT; a_link_text_color: like link_text_color)
		do
			link_text_color := a_link_text_color
			default_create
			set_font (a_font)

			disable_edit
			set_background_color (Color.text_field_background)
			set_tab_width (Screen.horizontal_pixels (0.5))
			create style.make (a_font, background_color)

			make_default
		end

	make_default
		do
			create text_blocks.make (5)
			create page_title.make_empty
			create link_stack.make (1)
			create external_links.make_empty
		end

feature -- Access

	link_text_color: EL_COLOR

	external_links: EL_ARRAYED_LIST [EL_HYPERLINK]

	navigation_links: ARRAYED_LIST [EL_HTML_TEXT_HYPERLINK_AREA]
		local
			content_link: EL_HTML_TEXT_HYPERLINK_AREA
			super_link: EL_SUPER_HTML_TEXT_HYPERLINK_AREA
			most_frequent_level, max_count, count, threshold_level: INTEGER
		do
			create Result.make (text_blocks.count // 3)
			-- Find which level has the most nodes
			across 3 |..| Content_levels.upper as level loop
				count := header_occurrences (level.item)
				if count > max_count then
					max_count := count
					most_frequent_level := level.item
				end
			end
			if max_count >= Minium_header_count_for_expansion then
				threshold_level := most_frequent_level - 1
			end
			across header_list as header loop
				if content_levels.has (header.item.level) then
					if header.item.level <= threshold_level then
						create super_link.make (Current, header.item)
						content_link := super_link
					else
						create content_link.make (Current, header.item)
						if attached super_link as l_super_link then
							l_super_link.sub_links.extend (content_link)
						end
					end
					content_link.set_link_text_color (link_text_color)
					Result.extend (content_link)
				end
			end
		end

	header_occurrences (level: INTEGER): INTEGER
		do
			across header_list as header loop
				if header.item.level = level then
					Result := Result + 1
				end
			end
		end

	page_title: ZSTRING

	style: EL_TEXT_FORMATTING_STYLES

feature -- Status query

	is_hyper_link_active: BOOLEAN
		do
			Result := not link_stack.is_empty and then not link_stack.item.href.is_empty
		end

feature {NONE} -- Ordered list Xpath events

	on_ordered_list
		do
			list_item_number := 1
			block_indent := block_indent + 1
		end

	on_ordered_list_close
		do
			block_indent := block_indent - 1
		end

	on_ordered_list_item
		do
			text_blocks.extend (create {EL_FORMATTED_NUMBERED_PARAGRAPHS}.make (style, block_indent, list_item_number))
			list_item_number := list_item_number + 1
		end

	on_ordered_list_start
		do
			list_item_number := last_node.to_integer
		end

feature {NONE} -- Unordered list Xpath events

	on_unordered_list
		do
			block_indent := block_indent + 1
		end

	on_unordered_list_close
		do
			block_indent := block_indent - 1
		end

	on_unordered_list_item
		do
			text_blocks.extend (create {EL_FORMATTED_BULLETED_PARAGRAPHS}.make (style, block_indent))
		end

feature {NONE} -- Xpath event handlers

	on_anchor_close
		do
			if link_stack.item.is_navigable then
				external_links.extend (link_stack.item)
			end
			link_stack.remove
		end

	on_block_quote
		do
			block_indent := block_indent + 1
		end

	on_block_quote_close
		do
			block_indent := block_indent - 1
		end

	on_heading (level: INTEGER)
			--
		do
			text_blocks.extend (create {EL_FORMATTED_TEXT_HEADER}.make (style, block_indent, level))
		end

	on_html_close
			--
		local
			block_previous: EL_FORMATTED_TEXT_BLOCK
			interval: INTEGER_INTERVAL; offset: INTEGER
		do
			if not text_blocks.is_empty then
				block_previous := text_blocks.last
				across text_blocks as block loop
					block.item.separate_from_previous (block_previous)
					block_previous := block.item
				end
				block_previous.append_new_line
			end
			across text_blocks as block loop
				across block.item.paragraphs as paragraph loop
					buffered_append (paragraph.item.text.to_unicode, paragraph.item.format)
				end
			end
			flush_buffer
			across text_blocks as block loop
				block.item.set_offset (offset)
				interval := block.item.interval
				format_paragraph (interval.lower, interval.upper, block.item.format.paragraph)
				offset := offset + block.item.count
			end
			external_links.order_by (agent link_name_as_lower, True)
		end

	on_line_break
		do
			text_blocks.last.append_new_line
		end

	on_paragraph
			--
		do
			text_blocks.extend (create {EL_FORMATTED_TEXT_BLOCK}.make (style, block_indent))
		end

	on_preformatted
			--
		do
			text_blocks.extend (create {EL_FORMATTED_MONOSPACE_TEXT}.make (style, block_indent))
		end

	on_text
		local
			l_text: ZSTRING
		do
			if not last_node.is_empty then
				if attached {EL_FORMATTED_MONOSPACE_TEXT} text_blocks.last as preformatted then
					preformatted.append_text (last_node.raw_string (False))
				else
					l_text := last_node.to_trim_lines.joined_words
					if is_hyper_link_active then
						text_blocks.last.enable_blue
						link_stack.item.append_text (l_text)
					end
					text_blocks.last.append_text (l_text)
					if is_hyper_link_active then
						text_blocks.last.disable_blue
					end
				end
			end
		end

	on_title
		do
			on_heading (1)
		end

	on_title_close
		do
			if attached {EL_FORMATTED_TEXT_HEADER} text_blocks.last as title_header then
				page_title := title_header.text
			end
			if not Headers_to_include.has (1) then
				text_blocks.finish; text_blocks.remove
			end
		end

feature {EL_HTML_TEXT_HYPERLINK_AREA} -- Implementation

	content_heading_font (a_header: EL_FORMATTED_TEXT_HEADER): EV_FONT
		do
			Result := a_header.format.character.font.twin
			Result.set_weight (Text_font.Weight_regular)
			Result.set_height ((Result.height * Content_height_proportion).rounded)
		end

	header_list: ARRAYED_LIST [EL_FORMATTED_TEXT_HEADER]
		do
			create Result.make (20)
			across text_blocks as paragraph loop
				if attached {EL_FORMATTED_TEXT_HEADER} paragraph.item as header then
					Result.extend (header)
				end
			end
		end

	link_name_as_lower (link: like external_links.item): ZSTRING
		-- sort routine for `external_links'
		do
			Result := link.text.as_lower
		end

	scroll_to_heading_line (heading_caret_position: INTEGER)
			--
		do
			scroll_to_line (line_number_from_position (heading_caret_position))
			set_focus
		end

	xpath_match_events: ARRAY [EL_XPATH_TO_AGENT_MAP]
			--
		local
			l_result: ARRAYED_LIST [EL_XPATH_TO_AGENT_MAP]
		do
			create l_result.make_from_array (<<
				[on_open, "//p",  				agent on_paragraph],

				[on_open, "//title", 			agent on_title],
				[on_close, "//title", 			agent on_title_close],

				[on_open, "//pre",  				agent on_preformatted],

				[on_open, "//ol",  				agent on_ordered_list],
				[on_open, "//ol/@start",		agent on_ordered_list_start],
				[on_close, "//ol", 	 			agent on_ordered_list_close],
				[on_open, "//ol/li", 			agent on_ordered_list_item],

				[on_open, "//ul",  				agent on_unordered_list],
				[on_close, "//ul", 	 			agent on_unordered_list_close],
				[on_open, "//ul/li", 			agent on_unordered_list_item],

				[on_open, "//text()", 			agent on_text],
				[on_open, "//br",  				agent on_line_break],

				[on_open, "//b", 					agent do text_blocks.last.enable_bold end],
				[on_close, "//b",  				agent do text_blocks.last.disable_bold end],

				[on_open, "//i", 					agent do text_blocks.last.enable_italic end],
				[on_close, "//i",  				agent do text_blocks.last.disable_italic end],

				[on_open, "//a",  				agent do link_stack.put (create {EL_HYPERLINK}.make_default) end],
				[on_open, "//a/@id",  			agent do link_stack.item.set_id (last_node) end],
				[on_open, "//a/@href",  		agent do link_stack.item.set_href (last_node) end],
				[on_close, "//a",  				agent on_anchor_close],

				[on_open, "//blockquote", 		agent on_block_quote],
				[on_close, "//blockquote",  	agent on_block_quote_close],

				[on_close, "/html", 				agent on_html_close]

			>>)
			across Headers_to_include as header_level loop
				l_result.extend ([on_open, "//h" + header_level.item.out, agent on_heading (header_level.item)])
			end
			Result := l_result.to_array
		end

feature {NONE} -- Internal attributes

	block_indent: INTEGER

	link_stack: ARRAYED_STACK [EL_HYPERLINK]

	list_item_number: INTEGER

	text_blocks: ARRAYED_LIST [EL_FORMATTED_TEXT_BLOCK]

feature {NONE} -- Constants

	Content_height_proportion: REAL = 0.9

	Content_levels: INTEGER_INTERVAL
		once
			Result  := 2 |..| 5
		end

	Headers_to_include: INTEGER_INTERVAL
			-- Heading 1 excluded
		once
			Result := 2 |..| 6
		end

	Minium_header_count_for_expansion: INTEGER = 23
		-- minimum number of headers nodes for grouping with EL_SUPER_HTML_TEXT_HYPERLINK_AREA to occur

end