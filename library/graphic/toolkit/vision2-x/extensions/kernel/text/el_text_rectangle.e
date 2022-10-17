note
	description: "[
		Container for wrapping text into a rectangular area before rendering it with a drawing command
		
		**Supports**
		
			* Multiple simultaneous font sizes
			* Word wrapping
			* Squeezing of text into available space by adjusting the font size
			* Rotation of text area
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-17 13:43:30 GMT (Monday 17th October 2022)"
	revision: "16"

class
	EL_TEXT_RECTANGLE

inherit
	EL_RECTANGLE
		redefine
			make
		end

	EL_HYPENATEABLE
		undefine
			out
		end

	EL_TEXT_ALIGNMENT
		export
			{ANY} Left_alignment, Center_alignment, Right_alignment
			{EL_ALIGNED_TEXT} alignment_code
		undefine
			out
		end

	EL_ZSTRING_CONSTANTS

	EL_MODULE_LIO

	EL_MODULE_GUI

create
	make_cms, make, make_from_rectangle

feature {NONE} -- Initialization

	make (a_x, a_y, a_width, a_height: INTEGER)
		do
			Precursor (a_x, a_y, a_width, a_height)
			create font
			create internal_lines.make (2)
			align_text_left; align_text_top
		end

	make_from_rectangle (r: EL_RECTANGLE)
		do
			make (r.x, r.y, r.width, r.height)
		end

feature -- Access

	font: EV_FONT

	lines: like word_wrapped_lines
		do
			create Result.make (internal_lines.count)
			across internal_lines as line loop
				Result.extend (line.item.text)
			end
		end

feature -- Measurement

	available_height: INTEGER
		do
			Result := height
			across internal_lines as line loop
				Result := Result - line.item.height
			end
			Result := Result.max (0)
		end

	bottom_most_y: INTEGER
		-- y coordinate of bottom of bottom-most line
		do
			if internal_lines.count > 0 then
				Result := internal_lines.last.bottom
			end
		end

	line_count: INTEGER
		do
			Result := internal_lines.count
		end

feature -- Status query

	is_text_squeezable: BOOLEAN
		-- if true allows squeezing of text into available space by reducing font size

	line_fits (line: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := Text.string_width (line, font) <= width
		end

feature -- Status setting

	disable_squeezing
		-- disable text squeezing
		do
			is_text_squeezable := False
		end

	enable_squeezing
		-- enable squeezing of text into available space by reducing font size
		do
			is_text_squeezable := True
		end

feature -- Element change

	add_separation (a_separation_cms: REAL)
		local
			separator: EL_ALIGNED_TEXT; l_bottom: INTEGER
		do
			separator := new_aligned_text ("")
			separator.set_height (Screen.vertical_pixels (a_separation_cms))
			l_bottom := bottom_most_y
			if l_bottom > 0 then
				separator.set_y (l_bottom + 1)
			end
			internal_lines.extend (separator)
		end

	append_line (a_line: READABLE_STRING_GENERAL)
			-- append line without wrapping
		local
			zstring: EL_ZSTRING_ROUTINES
		do
			if is_text_squeezable then
				squeeze_line (zstring.as_zstring (a_line))
			else
				extend_lines (zstring.as_zstring (a_line))
			end
		end

	append_paragraphs (list: ITERABLE [READABLE_STRING_GENERAL]; separation_cms: REAL)
		local
			i: INTEGER
		do
			across list as l loop
				if i > 0 then
					add_separation (separation_cms)
				end
				append_words (l.item)
				i := i + 1
			end
		end

	append_words (line: READABLE_STRING_GENERAL)
			-- append words wrapping them if they do not fit in one line
		do
			if is_text_squeezable then
				squeeze_flow_text (line)
			else
				flow_text (line)
			end
		end

	set_font (a_font: like font)
		do
			font := a_font.twin
		end

feature -- Basic operations

	draw (canvas: EL_DRAWABLE)
		do
			across internal_lines as line loop
				if not line.item.text.is_empty then
					line.item.align (Current)
					line.item.draw (canvas)
				end
			end
		end

	draw_border (canvas: EL_DRAWABLE)
		do
			canvas.draw_rectangle (x, y, width, height)
		end

	draw_rotated_border (canvas: EL_DRAWABLE; a_angle: DOUBLE)
		local
			rect: EL_MODEL_ROTATED_RECTANGLE
		do
			create rect.make_rotated (width, height, a_angle)
			rect.move (x, y)
			rect.draw (canvas)
		end

	draw_rotated_top_left (canvas: EL_DRAWABLE; a_angle: DOUBLE)
		local
			text_group: like line_text_group
			line: EL_ALIGNED_TEXT
		do
			text_group := line_text_group
			text_group.rotate_around (a_angle, x, y)
			across text_group as text_point loop
				line := internal_lines [text_point.cursor_index]
				if attached {EV_MODEL_DOT} text_point.item as point then
					canvas.set_font (line.font)
					canvas.draw_rotated_text (point.x, point.y, a_angle.truncated_to_real.opposite, line.text)
				end
			end
		end

feature -- Removal

	wipe_out
		do
			internal_lines.wipe_out
		end

feature {NONE} -- Implementation

	extend_lines (a_line: ZSTRING)
		do
			internal_lines.extend (new_aligned_text (a_line))
		end

	flow_text (line: READABLE_STRING_GENERAL)
		do
			across word_wrapped_lines (line) as l_line loop
				extend_lines (l_line.item)
			end
		end

	hypenate_word (words: EL_SEQUENTIAL_INTERVALS; line, line_out: ZSTRING)
		local
			old_count, i: INTEGER; outside_bounds: BOOLEAN
		do
			if words.item_count >= 4 then
				old_count := line_out.count
				-- check if part of word will fit
				if not line_out.is_empty then
					line_out.append_character (' ')
				end
				line_out.append_substring (line, words.item_lower, words.item_lower + 1)
				line_out.append_character ('-')

				if line_fits (line_out) then
					from i := words.item_lower + 2 until i > words.item_upper or outside_bounds loop
						line_out.insert_character (line [i], line_out.count)
						if line_fits (line_out) then
							i := i + 1
						else
							outside_bounds := True
							line_out.remove_substring (line_out.count - 1, line_out.count - 1) -- Undo insertion
						end
					end
					words.replace (i, words.item_upper)
					if words.item_count = 1
						or else words.item_count = 2
									and then line.is_alpha_item (i)
									and then is_comma_or_dot (line [i + 1])
					then
						line_out.remove_tail (1)
						line_out.append_substring (line, i, words.item_upper)
						words.replace (words.item_upper + 1, words.item_upper) -- set to zero
					end
				else
					line_out.keep_head (old_count)
				end
			end
		end

	line_text_group: EV_MODEL_GROUP
		local
			line: EL_ALIGNED_TEXT
		do
			create Result.make_with_position (x, y)
			across internal_lines as list loop
				line := list.item
				line.align (Current)
				Result.extend (create {EV_MODEL_DOT}.make_with_position (line.x, line.y))
			end
		end

	is_comma_or_dot (c: CHARACTER_32): BOOLEAN
		do
			inspect c
				when ',', '.' then
					Result := True
			else
			end
		end

	new_aligned_text (a_text: ZSTRING): EL_ALIGNED_TEXT
		do
			create Result.make (a_text, Current)
		end

	squeeze_flow_text (line: READABLE_STRING_GENERAL)
			-- append words, decreasing font size until text fits
		local
			appended: BOOLEAN; old_font: like font
			wrapped_lines: EL_ZSTRING_LIST
		do
			old_font := font.twin
			from  until font.height < 4 or appended loop
				wrapped_lines := word_wrapped_lines (line)
				if Text.widest_width (wrapped_lines, font) <= width
					and then wrapped_lines.count * font.line_height <= available_height
				then
					flow_text (line)
					appended := True
				else
					font.set_height (font.height - 1)
				end
			end
			font := old_font
		end

	squeeze_line (a_line: ZSTRING)
			-- append line, reducing font size so the line fits in available space
		local
			appended: BOOLEAN
			old_font: like font
		do
			old_font := font.twin
			from until font.height < 4 or appended loop
				if font.line_height <= available_height and then line_fits (a_line) then
					extend_lines (a_line)
					appended := True
				else
					font.set_height (font.height - 1)
				end
			end
			font := old_font
		end

	word_wrapped_lines (a_line: READABLE_STRING_GENERAL): EL_ZSTRING_LIST
		local
			line_out: ZSTRING; old_count: INTEGER; words: EL_SPLIT_ZSTRING_LIST
			line: ZSTRING; zstring: EL_ZSTRING_ROUTINES
		do
			create Result.make (0); create line_out.make_empty; line := zstring.as_zstring (a_line)

			create words.make (line, ' ')
			if is_lio_enabled then
				lio.put_line (a_line)
				lio.put_line ("WRAPPED")
				lio.put_new_line
			end
			from words.start until words.after loop
				old_count := line_out.count
				if not line_out.is_empty then
					line_out.append_character (' ')
				end
				words.append_item_to (line_out)
				if line_fits (line_out) then
					words.forth
				else
					if is_hyphenated then
						line_out.keep_head (old_count)
						hypenate_word (words, line, line_out)
						if words.item_count = 0 then
							-- word might be empty if it ended with a comma and had one alpha character
							words.forth
						end
					else
						if words.item_same_as (line_out) then
							-- Allow a line consisting of a single word even though it's too wide
							words.forth
						else
							line_out.keep_head (old_count)
						end
					end
					Result.extend (line_out.twin)
					line_out.wipe_out
				end
			end
			if not line_out.is_empty then
				Result.extend (line_out)
			end
			if is_lio_enabled then
				across Result as l loop
					lio.put_line (l.item)
				end
				lio.put_new_line
			end
		end

feature {EV_ANY_HANDLER} -- Internal attributes

	internal_lines: EL_ARRAYED_LIST [EL_ALIGNED_TEXT]

end