note
	description: "Summary description for {EL_EV_LABEL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-24 15:21:42 GMT (Wednesday 24th July 2013)"
	revision: "4"

class
	EL_LABEL

inherit
	EV_LABEL
		redefine
			initialize, set_text
		end

	EL_MODULE_GUI
		undefine
			is_equal, copy, default_create
		end

create
	default_create, make_with_text, make_with_wrapped_text

feature {NONE} -- Initialization

	make_with_wrapped_text (a_text: EL_ASTRING)
			--
		require
			a_text_not_void: a_text /= Void
		do
			default_create
			set_wrapped_text (a_text)
		end

	initialize
		do
			Precursor
			create timer.make_with_interval (0)
			create unwrapped_text.make_empty
			resize_actions.extend (agent on_resize)
		end

feature -- Element change

	set_wrapped_text (a_text: EL_ASTRING)
			--
		do
			unwrapped_text := a_text
			if GUI.is_word_wrappable (a_text, font, width) then
				set_text (GUI.word_wrapped (a_text, font, width))
				is_wrapped := True
			else
				GUI.do_once_on_idle (agent wrap_text)
			end
		end

	set_transient_text (a_text: EL_ASTRING; timeout_secs: REAL)
		do
			set_text (a_text)
			timer.set_interval ((1000 * timeout_secs).rounded)
			timer.actions.extend_kamikaze (agent remove_text)
			timer.actions.extend_kamikaze (agent set_foreground_color (GUI.default_foreground_color))
		end

feature -- Element change

	set_text (a_text: READABLE_STRING_GENERAL)
		do
			if attached {EL_ASTRING} a_text as astring then
				Precursor (astring.to_unicode)
			else
				Precursor (a_text)
			end
		end

feature -- Access

	unwrapped_text: EL_ASTRING

feature {NONE} -- Implementation

	on_resize (a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER)
		do
			if is_wrapped then
				wrap_text
			end
		end

	wrap_text
		do
			set_text (GUI.word_wrapped (unwrapped_text, font, width))
			is_wrapped := True
		end

	is_wrapped: BOOLEAN

	timer: EV_TIMEOUT

end
