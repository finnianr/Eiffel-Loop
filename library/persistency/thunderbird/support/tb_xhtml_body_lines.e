note
	description: "Thunderbird HTML content lines translated to body content as XHTML"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-14 18:08:25 GMT (Tuesday 14th February 2023)"
	revision: "2"

class
	TB_XHTML_BODY_LINES

inherit
	TB_HTML_LINES
		redefine
			append_html_line, line_included
		end

create
	make

feature {NONE} -- Line states

	append_html_line (line: ZSTRING)
		local
			pos_class_paragraph: INTEGER; l_found: BOOLEAN
			div_lines: EL_ZSTRING_LIST
		do
			pos_class_paragraph := line.substring_index (Class_paragraph_image, 1)
			if pos_class_paragraph > 0 then
				line.remove_substring (pos_class_paragraph - 1, pos_class_paragraph + Class_paragraph_image.count - 1)
				create div_lines.make (20)
				div_lines.append (Image_divs.sub_list (1, 2))
				extend (line)
				from finish until l_found loop
					if across << Tag_start.image, Tag_start.anchor >> as l_tag some item.begins_with (l_tag.item) end then
						l_found := True
					else
						back
					end
				end
				from until after loop
					div_lines.extend (Spaces_4 + item)
					remove
				end
				state := agent find_paragraph (?, div_lines)
			else
				Precursor (line)
			end
		end

	find_paragraph (line: ZSTRING; div_lines: EL_ZSTRING_LIST)
		do
			if line.begins_with (Paragraph.open) then
				div_lines.append (Image_divs.sub_list (3, 4))
				state := agent find_paragraph_close (?, div_lines)
			end
			div_lines.extend (Spaces_4 + line)
		end

	find_paragraph_close (line: ZSTRING; div_lines: EL_ZSTRING_LIST)
		do
			div_lines.extend (Spaces_4 + line)
			if line.ends_with (Paragraph.close) then
				div_lines.append (Image_divs.sub_list (5, 6))
				append (div_lines)
				state := agent append_html_line
			end
		end

feature {NONE} -- Implementation

	line_included (line: ZSTRING): BOOLEAN
		do
			Result := not is_empty_tag_line (line)
		end

feature {NONE} -- Constants

	Class_paragraph_image: ZSTRING
		once
			Result := "[
				class="paragraph_image"
			]"
		end

	Image_divs: EL_ZSTRING_LIST
		once
			create Result.make_with_lines ("[
				<div class="paragraph_image">
					<div class="image">
					</div>
					<div class="paragraph">
					</div>
				</div>
			]")
			Result.indent (1)
			Result.expand_tabs (4)
		end

	Spaces_4: ZSTRING
		once
			create Result.make_filled (' ', 4)
		end
end