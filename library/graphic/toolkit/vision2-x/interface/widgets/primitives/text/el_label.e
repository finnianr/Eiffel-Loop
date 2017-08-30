note
	description: "Summary description for {EL_EV_LABEL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-30 12:40:39 GMT (Sunday 30th April 2017)"
	revision: "2"

class
	EL_LABEL

inherit
	EV_LABEL
		rename
			set_text as set_text_general
		redefine
			make_with_text, initialize,
			align_text_top, align_text_vertical_center, align_text_bottom
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

	EL_MODULE_SCREEN
		undefine
			is_equal, copy, default_create
		end

	EL_MODULE_STRING_32
		undefine
			is_equal, copy, default_create
		end

create
	default_create, make_with_text, make_wrapped, make_wrapped_to_width

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			create timer.make_with_interval (0)
			create unwrapped_text.make_empty
			resize_actions.extend (agent on_resize)
			resize_actions.block
		end

	make_default
		do
			default_create
		end

	make_with_text (a_text: READABLE_STRING_GENERAL)
		do
			if a_text.is_empty then
				make_default
			else
				Precursor (a_text.to_string_32)
			end
		end

	make_wrapped (a_text: ZSTRING)
			--
		require
			a_text_not_void: a_text /= Void
		do
			make_default
			set_text_wrapped (a_text)
		end

	make_wrapped_to_width (a_text: ZSTRING; a_font: EV_FONT; a_width: INTEGER)
		do
			make_default
			set_minimum_width (a_width)
			set_font (a_font)
			unwrapped_text := a_text
			is_wrapped := True
			wrap_text
		end

feature -- Access

	unwrapped_text: ZSTRING

feature -- Status query

	is_wrapped: BOOLEAN

feature -- Element change

	set_text (a_text: READABLE_STRING_GENERAL)
		do
			is_wrapped := False
			set_text_general (a_text.to_string_32)
		end

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

	set_text_wrapped_to_width_cms (a_text: ZSTRING; a_width_cms: REAL)
		do
			set_text_wrapped_to_width (a_text, Screen.horizontal_pixels (a_width_cms))
		end

	set_transient_text (a_text: ZSTRING; timeout_secs: REAL)
		do
			set_text (a_text)
			timer.set_interval ((1000 * timeout_secs).rounded)
			timer.actions.extend_kamikaze (agent remove_text)
			timer.actions.extend_kamikaze (agent set_foreground_color (GUI.default_foreground_color))
		end

feature -- Status setting

	align_text_bottom
			-- Display `text' vertically aligned at the bottom.
		do
			Precursor {EL_WORD_WRAPPABLE}
			Precursor {EV_LABEL}
		end

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

feature {NONE} -- Implementation

	on_resize (a_x, a_y, a_width, a_height: INTEGER)
		do
			if a_width > 5 and then is_wrapped then
				wrap_text
			end
		end

feature {NONE} -- Implementation

	adjusted_width: INTEGER
			-- Needed due to layout bug where right most character is obscured
		do
			Result := width - font.string_width (once "a") // 3
		end

	timer: EV_TIMEOUT

	wrap_text
		local
			wrapped: like wrapped_lines
		do
			if GUI.is_word_wrappable (unwrapped_text, font, adjusted_width) then
				wrapped := wrapped_lines (unwrapped_text)

				-- Align with top edge if more than one line
				if vertical_alignment_code = Alignment_center then
					if wrapped.count > 1 then
						align_text_top
						vertical_alignment_code := Alignment_center
					else
						align_text_vertical_center
					end
				end
--				resize_actions.block
				set_text_general (wrapped.joined_lines.to_string_32)
--				resize_actions.resume
			else
				GUI.do_once_on_idle (agent wrap_text)
			end
		end

end
