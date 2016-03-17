note
	description: "Summary description for {EL_EV_LABEL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-26 11:23:04 GMT (Saturday 26th December 2015)"
	revision: "8"

class
	EL_LABEL

inherit
	EV_LABEL
		rename
			set_text as set_text_general
		redefine
			initialize, align_text_top, align_text_vertical_center, align_text_bottom
		end

	EL_WORD_WRAPPABLE
		rename
			width as adjusted_width
		undefine
			is_equal, copy, default_create, is_left_aligned, is_center_aligned, is_right_aligned,
			align_text_center, align_text_left, align_text_right
		redefine
			align_text_top, align_text_vertical_center, align_text_bottom
		end

create
	default_create, make_with_text, make_wrapped, make_wrapped_to_width

feature {NONE} -- Initialization

	make_wrapped (a_text: ZSTRING)
			--
		require
			a_text_not_void: a_text /= Void
		do
			default_create
			set_text_wrapped (a_text)
		end

	make_wrapped_to_width (a_text: ZSTRING; a_font: EV_FONT; a_width: INTEGER)
		do
			default_create
			set_minimum_width (a_width)
			set_font (a_font)
			unwrapped_text := a_text
			is_wrapped := True
			wrap_text
		end

	initialize
		do
			Precursor
			create timer.make_with_interval (0)
			create unwrapped_text.make_empty
			resize_actions.extend (agent on_resize)
			resize_actions.block
		end

feature -- Access

	unwrapped_text: ZSTRING

feature -- Element change

	set_text_wrapped (a_text: ZSTRING)
		-- wraps during component resizing
		do
			unwrapped_text := a_text
			is_wrapped := True
			resize_actions.resume
		end

	set_text_wrapped_to_width (a_text: ZSTRING; a_width: INTEGER)
			-- does an immediate wrap
		do
			set_minimum_width (a_width)
			unwrapped_text := a_text
			is_wrapped := True
			wrap_text
		end

	set_transient_text (a_text: ZSTRING; timeout_secs: REAL)
		do
			set_text (a_text)
			timer.set_interval ((1000 * timeout_secs).rounded)
			timer.actions.extend_kamikaze (agent remove_text)
			timer.actions.extend_kamikaze (agent set_foreground_color (GUI.default_foreground_color))
		end

	set_text (a_text: ZSTRING)
		do
			is_wrapped := False
			set_text_general (a_text.to_unicode)
		end

feature -- Status setting

	align_text_top
			-- Display `text' vertically aligned at the top.
		do
			Precursor {EL_WORD_WRAPPABLE}
			Precursor {EV_LABEL}
		end

	align_text_vertical_center
			-- Display `text' vertically aligned at the center.
		do
			Precursor {EL_WORD_WRAPPABLE}
			Precursor {EV_LABEL}
		end

	align_text_bottom
			-- Display `text' vertically aligned at the bottom.
		do
			Precursor {EL_WORD_WRAPPABLE}
			Precursor {EV_LABEL}
		end

feature {NONE} -- Implementation

	on_resize (a_x, a_y, a_width, a_height: INTEGER)
		do
			if a_width > 5 and then is_wrapped then
				wrap_text
			end
		end

feature {NONE} -- Implementation

	wrap_text
		local
			l_wrapped_lines: like wrapped_lines
		do
			if GUI.is_word_wrappable (unwrapped_text, font, adjusted_width) then
				l_wrapped_lines := wrapped_lines (unwrapped_text)

				-- Align with top edge if more than one line
				if vertical_alignment_code = Alignment_center then
					if l_wrapped_lines.count > 1 then
						align_text_top
						vertical_alignment_code := Alignment_center
					else
						align_text_vertical_center
					end
				end
--				resize_actions.block
				set_text_general (l_wrapped_lines.joined_lines.to_unicode)
--				resize_actions.resume
			else
				GUI.do_once_on_idle (agent wrap_text)
			end
		end

	adjusted_width: INTEGER
			-- Needed due to layout bug where right most character is obscured
		do
			Result := width - font.string_width (once "a") // 3
		end

	is_wrapped: BOOLEAN

	timer: EV_TIMEOUT

end
