note
	description: "Summary description for {EL_TEXT_RECTANGLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_TEXT_RECTANGLE

inherit
	EL_RECTANGLE
		redefine
			make
		end

	EV_TEXT_ALIGNMENT
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
			Precursor (a_x, a_y, a_width, a_height)
			create font
			create lines.make (2)
			set_left_alignment
		end

feature -- Access

	font: EL_FONT

feature -- Element change

	set_font (a_font: like font)
		do
			font := a_font.twin
		end

	squeeze_flow_text (a_text: EL_ASTRING)
			-- Decrease font size until text fits
		local
			text_small_enough: BOOLEAN
			existing_lines: like lines
			l_font: EL_FONT
		do
			log.enter_with_args ("squeeze_flow_text", << a_text >>)
			create existing_lines.make (lines.count)
			existing_lines.append (lines)
			l_font := font.twin
			from  until font.height < 4 or text_small_enough loop
				flow_text (a_text)
				text_small_enough := not overflowed

				log.put_labeled_string ("text_small_enough", " "); log.put_boolean (text_small_enough)
				log.put_new_line

				if not text_small_enough then
					font.set_height ((font.height * 0.9).rounded)
					lines.wipe_out
					lines.append (existing_lines)
				end
			end
			font := l_font
			log.exit
		end

	flow_text (a_text: EL_ASTRING)
		local
			words, line: EL_STRING_LIST [EL_ASTRING]
			i: INTEGER
		do
			create words.make_with_words (a_text)
			from i := 1 until i > words.count loop
				line := longest_line (i, words)
				lines.extend (create_line (line.joined_words))
				i := i + line.count
			end
		end

	longest_line (start_index: INTEGER; words: EL_STRING_LIST [EL_ASTRING]): EL_STRING_LIST [EL_ASTRING]
		require
			words_available: start_index <= words.count
		local
			i: INTEGER
			line_width_exceeded: BOOLEAN
		do
			create Result.make (5)
			from i := start_index until line_width_exceeded or i > words.count loop
				Result.extend (words [i])
				line_width_exceeded := font.string_width (Result.joined_words.to_unicode) > width
				if line_width_exceeded then
					Result.remove_last
				end
				i := i + 1
			end
			-- Force a single word even if it's too wide
			if Result.is_empty then
				Result.extend (words [start_index])
			end
		end

	add_separation (a_separation_cms: REAL)
		local
			separator: like Type_line
		do
			separator := create_line ("")
			separator.rectangle.set_height (Screen.vertical_pixels (a_separation_cms))
			if not lines.is_empty then
				separator.rectangle.set_y (lines.last.rectangle.bottom + 1)
			end
			lines.extend (separator)
		end

feature -- Basic operations

	draw (canvas: EL_DRAWABLE)
		local
			rect: EL_RECTANGLE
		do
			across lines as line loop
				if not line.item.text.is_empty then
					rect := aligned_rectangle (line.item)
					canvas.set_font (line.item.font)
					canvas.draw_text_top_left (rect.x, rect.y, line.item.text.to_unicode)
				end
			end
		end

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

	draw_rotated_top_left (canvas: EL_DRAWABLE; a_angle: DOUBLE)
		local
			text_group: like line_text_group
			line: like Type_line
		do
			text_group := line_text_group
			text_group.rotate_around (a_angle, x, y)
			across text_group as text_point loop
				line := lines [text_point.cursor_index]
				if not line.is_empty and then attached {EV_MODEL_DOT} text_point.item as point then
					canvas.set_font (line.font)
					canvas.draw_rotated_text (point.x, point.y, a_angle.truncated_to_real.opposite, line.text.to_unicode)
				end
			end
		end

feature -- Status query

	overflowed: BOOLEAN
		do
			Result := not lines.is_empty implies
				(not has_x_y (x, lines.last.rectangle.bottom)
					or else across lines as line some font.string_width (line.item.text.to_unicode) > width end)
		end

feature -- Removal

	wipe_out
		do
			lines.wipe_out
		end

feature {NONE} -- Implementation

	create_line (a_text: EL_ASTRING): like Type_line
		local
			rect: EL_RECTANGLE
		do
			create Result
			Result.text := a_text
			Result.font := font.twin
			Result.alignment := alignment_code
			create rect.make (x, y, width, font.line_height)
			if not lines.is_empty then
				rect.set_y (lines.last.rectangle.bottom + 1)
			end
			Result.rectangle := rect
		end

	line_text_group: EV_MODEL_GROUP
		local
			r: EL_RECTANGLE
		do
			create Result.make_with_position (x, y)
			across lines as line loop
				r := aligned_rectangle (line.item)
				Result.extend (create {EV_MODEL_DOT}.make_with_position (r.left, r.bottom))
			end
		end

	lines: EL_ARRAYED_LIST [like Type_line]

feature {NONE} -- Type definitions

	Type_line: TUPLE [text: EL_ASTRING; font: EL_FONT; rectangle: EL_RECTANGLE; alignment: INTEGER]
		once
		end

end
