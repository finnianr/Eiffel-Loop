note
	description: "[
		Container for wrapping text into a rectangular area before rendering it with a drawing command
		
		Supports:
			* Multiple simultaneous font sizes
			* Word wrapping
			* Squeezing of text into available space by adjusting the font size
			* Rotation of text area
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "3"

class
	EL_TEXT_RECTANGLE

inherit
	EL_CROSS_PLATFORM [EL_TEXT_RECTANGLE_IMP]
		undefine
			out
		end

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

create
	make_cms, make, make_from_rectangle

feature {NONE} -- Initialization

	make_from_rectangle (r: EL_RECTANGLE)
		do
			make (r.x, r.y, r.width, r.height)
		end

	make (a_x, a_y, a_width, a_height: INTEGER)
		do
			make_default
			Precursor (a_x, a_y, a_width, a_height)
			create font
			create internal_lines.make (2)
			align_text_left; align_text_top
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

	line_fits (line: ASTRING): BOOLEAN
		do
			Result := font.string_width (line.to_unicode) <= width
		end

feature -- Status setting

	enable_squeezing
		-- enable squeezing of text into available space by reducing font size
		do
			is_text_squeezable := True
		end

	disable_squeezing
		-- disable text squeezing
		do
			is_text_squeezable := False
		end

feature -- Element change

	set_font (a_font: like font)
		do
			font := a_font.twin
		end

	append_line (a_line: ASTRING)
			-- append line without wrapping
		do
			if is_text_squeezable then
				squeeze_line (a_line)
			else
				extend_lines (a_line)
			end
		end

	append_words (words: EL_ASTRING_LIST)
			-- append words wrapping them if they do not fit in one line
		do
			if is_text_squeezable then
				squeeze_flow_text (words)
			else
				flow_text (words)
			end
		end

	add_separation (a_separation_cms: REAL)
		local
			separator: like Type_line
		do
			separator := create_line ("")
			separator.rectangle.set_height (Screen.vertical_pixels (a_separation_cms))
			if not internal_lines.is_empty then
				separator.rectangle.set_y (internal_lines.last.rectangle.bottom + 1)
			end
			internal_lines.extend (separator)
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

	draw_rotated_border_on_buffer (buffer: EL_DRAWABLE_PIXEL_BUFFER; a_angle: DOUBLE)
		do
			buffer.save
			buffer.translate (x, y)
			buffer.rotate (a_angle)
			buffer.draw_rectangle (0, 0, width, height)
			buffer.restore
		end

	draw_rotated_on_buffer (buffer: EL_DRAWABLE_PIXEL_BUFFER; a_angle: DOUBLE)
		do
			implementation.draw_rotated_on_buffer (buffer, a_angle)
		end

	draw_rotated_border (canvas: EL_DRAWABLE; a_angle: DOUBLE)
		local
			rect: EL_ROTATABLE_RECTANGLE
		do
			create rect.make_rotated (width, height, a_angle)
			rect.move (x, y)
			rect.draw (canvas)
		end

	draw_rotated_top_left (canvas: EL_DRAWABLE; a_angle: DOUBLE)
		local
			text_group: like line_text_group
			line: like Type_line
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

feature {EL_TEXT_RECTANGLE_IMP} -- Implementation

	aligned_rectangle (line: like Type_line): EL_RECTANGLE
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

	squeeze_flow_text (words: EL_ASTRING_LIST)
			-- append words, decreasing font size until text fits
		local
			appended: BOOLEAN; old_font: like font
			wrapped_lines: EL_ASTRING_LIST
		do
			old_font := font.twin
			from  until font.height < 4 or appended loop
				wrapped_lines := word_wrapped_lines (words)
				if GUI.widest_width (wrapped_lines, font) <= width
					and then wrapped_lines.count * font.line_height <= available_height
				then
					flow_text (words)
					appended := True
				else
					font.set_height (font.height - 1)
				end
			end
			font := old_font
		end

	squeeze_line (a_line: ASTRING)
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

	flow_text (words: EL_ASTRING_LIST)
		do
			word_wrapped_lines (words).do_all (agent extend_lines)
		end

	extend_lines (a_line: ASTRING)
		do
			internal_lines.extend (create_line (a_line))
		end

	create_line (a_text: ASTRING): like Type_line
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

	word_wrapped_lines (words: EL_ASTRING_LIST): EL_ASTRING_LIST
		local
			line, word: ASTRING; stack: like new_word_stack
			old_count: INTEGER
		do
			create Result.make (0)
			create line.make_empty
			from stack := new_word_stack (words) until stack.is_empty loop
				word := stack.item
				old_count := line.count
				if not line.is_empty then
					line.append_character (' ')
				end
				line.append (word)
				if line_fits (line) then
					stack.remove
				else
					if is_hyphenated then
						line.keep_head (old_count)
						hypenate_word (word, line)
						if word.is_empty then
							-- word might be empty if it ended with a comma and had one alpha character
							stack.remove
						end
					else
						if line ~ word then
							-- Allow a line consisting of a single word even thought it's too wide
							stack.remove
						else
							line.keep_head (old_count)
						end
					end
					Result.extend (line.twin)
					line.wipe_out
				end
			end
			if not line.is_empty then
				Result.extend (line)
			end
		end

	hypenate_word (word, line: ASTRING)
		local
			old_count: INTEGER
		do
			if word.count >= 4 then
				old_count := line.count
				-- check if part of word will fit
				if not line.is_empty then
					line.append_character (' ')
				end
				line.append (word.substring (1, 2))
				line.append_character ('-')

				if line_fits (line) then
					word.remove_head (2)
					from until not line_fits (line) loop
						line.remove_tail (1)
						line.append_character (word [1])
						line.append_character ('-')
						word.remove_head (1)
					end
					word.prepend_character (line [line.count - 1])
					line.remove_tail (2)
					line.append_character ('-')
					if word.count = 1
						or else word.count = 2 and then word.is_alpha_item (1) and then (word [2] = ',' or word [2] = '.')
					then
						line.remove_tail (1)
						line.append (word)
						word.wipe_out
					end
				else
					line.keep_head (old_count)
				end
			end
		end

	new_word_stack (words: EL_ASTRING_LIST): ARRAYED_STACK [ASTRING]
		do
			create Result.make (words.count)
			from words.finish until words.before loop
				if is_hyphenated then
					Result.extend (words.item.twin)
				else
					Result.extend (words.item)
				end
				words.back
			end
		end

	hypenated_words (words: EL_ASTRING_LIST): EL_ASTRING_LIST
		do
			create Result.make (words.count)
		end

	line_text_group: EV_MODEL_GROUP
		local
			r: EL_RECTANGLE
		do
			create Result.make_with_position (x, y)
			across internal_lines as line loop
				r := aligned_rectangle (line.item)
				Result.extend (create {EV_MODEL_DOT}.make_with_position (r.x, r.y))
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

	internal_lines: EL_ARRAYED_LIST [like Type_line]

feature {NONE} -- Type definitions

	Type_line: TUPLE [text: ASTRING; font: EV_FONT; rectangle: EL_RECTANGLE; alignment: INTEGER]
		once
		end

end
