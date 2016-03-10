note
	description: "Summary description for {EL_HTML_TEXT_2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-06 10:29:51 GMT (Saturday 6th July 2013)"
	revision: "2"

class
	EL_HTML_TEXT

inherit
	EL_RICH_TEXT

	EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS
		rename
			make as make_xpath_match_events,
			build_from_file as set_text_from_xhtml_path
		undefine
			default_create, copy
		end

	EL_MODULE_GUI
		undefine
			default_create, copy
		end

	EL_MODULE_STRING
		undefine
			default_create, copy
		end

	EL_MODULE_SCREEN
		undefine
			default_create, copy
		end

	EL_MODULE_LOG
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

	make (a_font: EL_FONT; a_link_text_color: like link_text_color)
		do
			link_text_color := a_link_text_color
			default_create
			set_font (a_font)
			create paragraphs.make

			disable_edit
			set_background_color (GUI.text_field_background_color)
			set_tab_width (Screen.horizontal_pixels (0.5))
			create style.make (a_font, background_color)
			make_xpath_match_events
		end

feature -- Access

	navigation_links: LINKED_LIST [TUPLE [level: INTEGER; link: EL_HYPERLINK_AREA]]
		local
			content_link: EL_HYPERLINK_AREA
			level_3_link: EL_HTML_TEXT_HYPERLINK_AREA
		do
			create Result.make
			across paragraphs as paragraph loop
				if attached {EL_HTML_HEADER} paragraph.item as header then
					if content_levels.has (header.level) then
						if header.level = 3 then
							create level_3_link.make (
								header.text, agent scroll_to_heading_line (header.lower_pos),
								content_heading_font (header), GUI.text_field_background_color
							)
							content_link := level_3_link
						else
							create content_link.make (
								header.text, agent scroll_to_heading_line (header.lower_pos),
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

	style: EL_HTML_STYLE

	link_text_color: EL_COLOR

feature {NONE} -- Xpath event handlers

	on_heading (level: INTEGER)
			--
		do
			paragraphs.extend (create {EL_HTML_HEADER}.make (style, block_indent, level))
		end

	on_paragraph
			--
		do
			paragraphs.extend (create {EL_HTML_PARAGRAPH}.make (style, block_indent))
		end

	on_preformatted
			--
		do
			paragraphs.extend (create {EL_HTML_PREFORMATTED_PARAGRAPH}.make (style, block_indent))
		end

	on_html_end
			--
		local
			l_total_count: INTEGER_REF
			paragraph_previous: EL_HTML_PARAGRAPH
		do
			create l_total_count
			create paragraph_previous.make (style, 0)
			across paragraphs as paragraph loop
				paragraph.item.separate_from_previous (paragraph_previous)
				paragraph_previous := paragraph.item
			end
			across paragraphs as paragraph loop
				paragraph.item.attach_to_rich_text (Current, l_total_count)
			end
			flush_buffer
			across paragraphs as paragraph loop
				format_paragraph (paragraph.item.lower_pos, paragraph.item.upper_pos, paragraph.item.format.paragraph)
			end
		end

	on_numbered_list_start
		do
			list_item_number := 0
			block_indent := block_indent + 1
		end

	on_numbered_list_end
		do
			block_indent := block_indent - 1
		end

	on_numbered_list_item
		do
			list_item_number := list_item_number + 1
			paragraphs.extend (create {EL_HTML_NUMBERED_PARAGRAPH}.make (style, block_indent, list_item_number))
		end

	on_text
		do
			if not last_node.is_empty then
				if attached {EL_HTML_PREFORMATTED_PARAGRAPH} paragraphs.last as preformatted then
					preformatted.append_text (last_node.to_raw_string)
				else
					paragraphs.last.append_text (last_node.to_string)
				end
			end
		end

	on_line_break
		do
--			if attached {EL_HTML_PREFORMATTED_PARAGRAPH} paragraphs.last then
--				on_preformatted
--			else
				paragraphs.last.append_new_line
--			end
		end

	on_block_quote
		do
			block_indent := block_indent + 1
		end

	on_block_quote_end
		do
			block_indent := block_indent - 1
		end

feature {NONE} -- Implementation

	xpath_match_events: ARRAY [like Type_agent_mapping]
			--
		local
			l_result: ARRAYED_LIST [like Type_agent_mapping]
			l_xpath: STRING
		do
			create l_result.make_from_array (<<
				["/html", on_node_end, 				agent on_html_end],
				["//p", on_node_start, 				agent on_paragraph],

				["//pre", on_node_start, 			agent on_preformatted],

				["//ol", on_node_start, 			agent on_numbered_list_start],
				["//ol", on_node_end,	 			agent on_numbered_list_end],
				["//ol/li", on_node_start,			agent on_numbered_list_item],

				["//text()", on_node_start, 		agent on_text],
				["//br", on_node_start, 			agent on_line_break],

				["//i", on_node_start,				agent do paragraphs.last.enable_italic end],
				["//i", on_node_end, 				agent do paragraphs.last.disable_italic end],

				["//a", on_node_start, 				agent do paragraphs.last.enable_blue end],
				["//a", on_node_end, 				agent do paragraphs.last.disable_blue end],

				["//blockquote", on_node_start,	agent on_block_quote],
				["//blockquote", on_node_end,  	agent on_block_quote_end]

			>>)
			across 1 |..| 6 as header_level loop
				if header_level.item = 1 then
					l_xpath := "//title"
				else
					l_xpath := "//h" + header_level.item.out
				end
				l_result.extend ([l_xpath, on_node_start, agent on_heading (header_level.item)])
			end
			Result := l_result.to_array
		end

	content_heading_font (a_header: EL_HTML_HEADER): EV_FONT
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

	paragraphs: LINKED_LIST [EL_HTML_PARAGRAPH]

feature {NONE} -- Constants

	Content_levels: INTEGER_INTERVAL
		once
			Result  := 2 |..| 5
		end

	Content_height_proportion: REAL = 0.9

end
