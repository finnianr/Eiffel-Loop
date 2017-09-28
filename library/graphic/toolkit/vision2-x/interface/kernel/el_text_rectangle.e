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
	date: "2017-08-14 18:41:35 GMT (Monday 14th August 2017)"
	revision: "3"

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
		undefine
			out
		end

	EL_MODULE_LOG
		undefine
			out
		end

	EL_MODULE_GUI
		undefine
			out
		end

	EL_STRING_CONSTANTS
		undefine
			out
		end

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

	line_count: INTEGER
		do
			Result := internal_lines.count
		end

	lines: like word_wrapped_lines
		do
			create Result.make (internal_lines.count)
			across internal_lines as line loop
				Result.extend (line.item.text)
			end
		end

feature -- Status query

	is_text_squeezable: BOOLEAN
		-- if true allows squeezing of text into available space by reducing font size

	line_fits (line: ZSTRING): BOOLEAN
		do
			Result := GUI.string_width (line, font) <= width
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
			separator: like STYLED_TEXT
		do
			separator := create_line ("")
			separator.rectangle.set_height (Screen.vertical_pixels (a_separation_cms))
			if not internal_lines.is_empty then
				separator.rectangle.set_y (internal_lines.last.rectangle.bottom + 1)
			end
			internal_lines.extend (separator)
		end

	append_line (a_line: ZSTRING)
			-- append line without wrapping
		do
			if is_text_squeezable then
				squeeze_line (a_line)
			else
				extend_lines (a_line)
			end
		end

	append_words (line: ZSTRING)
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
		local
			rect: EL_RECTANGLE
		do
			across internal_lines as line loop
				if not line.item.text.is_empty then
					rect := aligned_rectangle (line.item)
					canvas.set_font (line.item.font)
					canvas.draw_text_top_left (rect.x, rect.y, line.item.text.to_unicode)
				end
			end
		end

	draw_border (canvas: EL_DRAWABLE)
		do
			canvas.draw_rectangle (x, y, width, height)
		end

	draw_rotated_border (canvas: EL_DRAWABLE; a_angle: DOUBLE)
		local
			rect: EL_ROTATABLE_RECTANGLE
		do
			create rect.make_rotated (width, height, a_angle)
			rect.move (x, y)
			rect.draw (canvas)
		end

	draw_rotated_border_on_buffer (buffer: EL_DRAWABLE_PIXEL_BUFFER; a_angle: DOUBLE)
		do
			buffer.save
			buffer.translate (x, y)
			buffer.rotate (a_angle)
			buffer.draw_rectangle (0, 0, width, height)
			buffer.restore
		end

	draw_rotated_on_buffer (buffer: EL_DRAWABLE_PIXEL_BUFFER; a_angle: DOUBLE)
		local
			rect: EL_RECTANGLE; line: like STYLED_TEXT
		do
			buffer.save
			buffer.translate (x, y)
			buffer.rotate (a_angle)
			buffer.set_antialias_best
			from internal_lines.start until internal_lines.after loop
				line := internal_lines.item
				if not line.is_empty then
					rect := aligned_rectangle (line)
					buffer.set_font (line.font)
					buffer.draw_text_top_left (rect.x - x, rect.y - y, line.text.to_unicode)
				end
				internal_lines.forth
			end
			buffer.restore
		end

	draw_rotated_top_left (canvas: EL_DRAWABLE; a_angle: DOUBLE)
		local
			text_group: like line_text_group
			line: like STYLED_TEXT
		do
			text_group := line_text_group
			text_group.rotate_around (a_angle, x, y)
			across text_group as text_point loop
				line := internal_lines [text_point.cursor_index]
				if not line.is_empty and then attached {EV_MODEL_DOT} text_point.item as point then
					canvas.set_font (line.font)
					canvas.draw_rotated_text (point.x, point.y, a_angle.truncated_to_real.opposite, line.text.to_unicode)
				end
			end
		end

feature -- Removal

	wipe_out
		do
			internal_lines.wipe_out
		end

feature {NONE} -- Implementation

	aligned_rectangle (line: like STYLED_TEXT): EL_RECTANGLE
		require
			valid_alignment: (<< Left_alignment, Center_alignment, Right_alignment >>).has (line.alignment)
		local
			difference: INTEGER
		do
			if line.text.is_empty or line.alignment = Left_alignment then
				Result := line.rectangle
			else
				Result := line.rectangle.twin
				difference := Result.width - line.font.string_width (line.text.to_unicode)
				inspect line.alignment
					when Right_alignment then
						Result.grow_left (difference.opposite)

					when Center_alignment then
						difference := difference // 2
						Result.grow_left (difference.opposite)
						Result.grow_right (difference.opposite)
				else
				end
			end
			if is_vertically_centered then
				Result.set_y (Result.y + available_height // 2)
			end
		end

	available_height: INTEGER
		do
			Result := height
			across internal_lines as line loop
				Result := Result - line.item.rectangle.height
			end
			Result := Result.max (0)
		end

	create_line (a_text: ZSTRING): like STYLED_TEXT
		local
			rect: EL_RECTANGLE
		do
			create Result
			Result.text := a_text
			Result.font := font.twin
			Result.alignment := alignment_code
			create rect.make (x, y, width, font.line_height)
			if not internal_lines.is_empty then
				rect.set_y (internal_lines.last.rectangle.bottom + 1)
			end
			Result.rectangle := rect
		end

	extend_lines (a_line: ZSTRING)
		do
			internal_lines.extend (create_line (a_line))
		end

	flow_text (line: ZSTRING)
		do
			word_wrapped_lines (line).do_all (agent extend_lines)
		end

	hypenate_word (words: EL_SEQUENTIAL_INTERVALS; line, line_out: ZSTRING)
		local
			old_count, word_lower: INTEGER; outside_bounds: BOOLEAN
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
					from word_lower := words.item_lower + 2 until word_lower > words.item_upper or outside_bounds loop
						line_out.insert_character (line [word_lower], line_out.count)
						if line_fits (line_out) then
							word_lower := word_lower + 1
						else
							outside_bounds := True
							line_out.remove_substring (line_out.count - 1, line_out.count - 1) -- Undo insertion
						end
					end
					words.replace (word_lower, words.item_upper)
					if words.item_count = 1
						or else words.item_count = 2
							and then line.is_alpha_item (word_lower) and then Comma_or_dot.has (line [word_lower + 1])
					then
						line_out.remove_tail (1)
						line_out.append_substring (line, word_lower, words.item_upper)
						words.replace (words.item_upper + 1, words.item_upper) -- set to zero
					end
				else
					line_out.keep_head (old_count)
				end
			end
		end

	line_text_group: EV_MODEL_GROUP
		local
			r: EL_RECTANGLE; line: like STYLED_TEXT
		do
			create Result.make_with_position (x, y)
			from internal_lines.start until internal_lines.after loop
				line := internal_lines.item
				r := aligned_rectangle (line)
				Result.extend (create {EV_MODEL_DOT}.make_with_position (r.x, r.y))
				internal_lines.forth
			end
		end

	squeeze_flow_text (line: ZSTRING)
			-- append words, decreasing font size until text fits
		local
			appended: BOOLEAN; old_font: like font
			wrapped_lines: EL_ZSTRING_LIST
		do
			old_font := font.twin
			from  until font.height < 4 or appended loop
				wrapped_lines := word_wrapped_lines (line)
				if GUI.widest_width (wrapped_lines, font) <= width
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

	word_wrapped_lines (line: ZSTRING): EL_ZSTRING_LIST
		local
			line_out: ZSTRING; old_count: INTEGER; words: EL_SEQUENTIAL_INTERVALS
		do
			create Result.make (0); create line_out.make_empty

			words := line.split_intervals (Space_string)
			from words.start until words.after loop
				old_count := line_out.count
				if not line_out.is_empty then
					line_out.append_character (' ')
				end
				line_out.append_substring (line, words.item_lower, words.item_upper)
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
						if line_out.same_characters (line, words.item_lower, words.item_upper, 1) then
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
		end

feature {NONE} -- Internal attributes

	internal_lines: EL_ARRAYED_LIST [like STYLED_TEXT]

feature {NONE} -- Constants

	STYLED_TEXT: TUPLE [text: ZSTRING; font: EV_FONT; rectangle: EL_RECTANGLE; alignment: INTEGER]
		once
			create Result
		end

	Comma_or_dot: ZSTRING
		once
			Result := ",."
		end
end
