note
	description: "Html text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_HTML_TEXT

inherit
	EL_RICH_TEXT

	EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS [EL_EXPAT_XML_PARSER]
		rename
			build_from_file as set_text_from_xhtml_path
		undefine
			default_create, copy
		end

	EL_MODULE_GUI
		undefine
			default_create, copy
		end

	EL_MODULE_SCREEN
		undefine
			default_create, copy
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			default_create, copy
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			create text_blocks.make
			create page_title.make_empty
		end

	make (a_font: EL_FONT; a_link_text_color: like link_text_color)
		do
			link_text_color := a_link_text_color
			default_create
			set_font (a_font)

			disable_edit
			set_background_color (GUI.text_field_background_color)
			set_tab_width (Screen.horizontal_pixels (0.5))
			create style.make (a_font, background_color)

			make_default
		end

feature -- Access

	navigation_links: LINKED_LIST [TUPLE [level: INTEGER; link: EL_HYPERLINK_AREA]]
		local
			content_link: EL_HYPERLINK_AREA
			level_3_link: EL_HTML_TEXT_HYPERLINK_AREA
		do
			create Result.make
			across text_blocks as paragraph loop
				if attached {EL_FORMATTED_TEXT_HEADER} paragraph.item as header then
					if content_levels.has (header.level) then
						if header.level = 3 then
							create level_3_link.make (
								header.text, agent scroll_to_heading_line (header.interval.lower),
								content_heading_font (header), GUI.text_field_background_color
							)
							content_link := level_3_link
						else
							create content_link.make (
								header.text, agent scroll_to_heading_line (header.interval.lower),
								content_heading_font (header), GUI.text_field_background_color
							)
							if header.level > 3 then
								level_3_link.sub_links.extend (content_link)
							end
						end
						content_link.set_link_text_color (link_text_color)
						Result.extend ([header.level, content_link])
					end
				end
			end
		end

	style: EL_TEXT_FORMATTING_STYLES

	link_text_color: EL_COLOR

	page_title: ZSTRING

feature {NONE} -- Xpath event handlers

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

	on_heading (level: INTEGER)
			--
		do
			text_blocks.extend (create {EL_FORMATTED_TEXT_HEADER}.make (style, block_indent, level))
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
		end

	on_numbered_list
		do
			list_item_number := 1
			block_indent := block_indent + 1
		end

	on_numbered_list_start
		do
			list_item_number := last_node.to_integer
		end

	on_numbered_list_close
		do
			block_indent := block_indent - 1
		end

	on_numbered_list_item
		do
			text_blocks.extend (create {EL_FORMATTED_NUMBERED_PARAGRAPHS}.make (style, block_indent, list_item_number))
			list_item_number := list_item_number + 1
		end

	on_text
		do
			if not last_node.is_empty then
				if attached {EL_FORMATTED_MONOSPACE_TEXT} text_blocks.last as preformatted then
					preformatted.append_text (last_node.to_raw_string)
				else
					text_blocks.last.append_text (last_node.to_trim_lines.joined_words)
				end
			end
		end

	on_line_break
		do
			text_blocks.last.append_new_line
		end

	on_block_quote
		do
			block_indent := block_indent + 1
		end

	on_block_quote_close
		do
			block_indent := block_indent - 1
		end

feature {NONE} -- Implementation

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

				[on_open, "//ol",  				agent on_numbered_list],
				[on_open, "//ol/@start",		agent on_numbered_list_start],
				[on_close, "//ol", 	 			agent on_numbered_list_close],
				[on_open, "//ol/li", 			agent on_numbered_list_item],

				[on_open, "//text()", 			agent on_text],
				[on_open, "//br",  				agent on_line_break],

				[on_open, "//b", 					agent do text_blocks.last.enable_bold end],
				[on_close, "//b",  				agent do text_blocks.last.disable_bold end],

				[on_open, "//i", 					agent do text_blocks.last.enable_italic end],
				[on_close, "//i",  				agent do text_blocks.last.disable_italic end],

				[on_open, "//a",  				agent do text_blocks.last.enable_blue end],
				[on_close, "//a",  				agent do text_blocks.last.disable_blue end],

				[on_open, "//blockquote", 		agent on_block_quote],
				[on_close, "//blockquote",  	agent on_block_quote_close],

				[on_close, "/html", 				agent on_html_close]

			>>)
			across Headers_to_include as header_level loop
				l_result.extend ([on_open, "//h" + header_level.item.out, agent on_heading (header_level.item)])
			end
			Result := l_result.to_array
		end

	content_heading_font (a_header: EL_FORMATTED_TEXT_HEADER): EV_FONT
		do
			Result := a_header.format.character.font.twin
			Result.set_weight (GUI.Weight_regular)
			Result.set_height ((Result.height * Content_height_proportion).rounded)
		end

	scroll_to_heading_line (heading_caret_position: INTEGER)
			--
		do
			scroll_to_line (line_number_from_position (heading_caret_position))
			set_focus
		end

	list_item_number: INTEGER

	block_indent: INTEGER

	text_blocks: LINKED_LIST [EL_FORMATTED_TEXT_BLOCK]

feature {NONE} -- Constants

	Content_levels: INTEGER_INTERVAL
		once
			Result  := 2 |..| 5
		end

	Content_height_proportion: REAL = 0.9

	Headers_to_include: INTEGER_INTERVAL
			-- Heading 1 excluded
		once
			Result := 2 |..| 6
		end

end
