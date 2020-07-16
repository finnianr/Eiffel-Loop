note
	description: "Label"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-16 10:45:04 GMT (Thursday 16th July 2020)"
	revision: "10"

class
	EL_LABEL

inherit
	EV_LABEL
		undefine
			set_text
		redefine
			implementation
		end

	EL_TEXTABLE
		undefine
			initialize, is_in_default_state
		redefine
			implementation
		end

	EL_MODULE_COLOR

create
	default_create, make_with_text

feature -- Element change

	set_transient_text (a_text: separate READABLE_STRING_GENERAL; timeout_secs: REAL)
		do
			if attached internal_timer as timer then
				set_text (a_text)
				timer.set_interval ((1000 * timeout_secs).rounded)
				timer.actions.extend_kamikaze (agent remove_text)
				timer.actions.extend_kamikaze (agent set_foreground_color (Color.Default_foreground))
			else
				create internal_timer.make_with_interval (0)
				set_transient_text (a_text, timeout_secs)
			end
		end

feature {NONE} -- Internal attributes

	internal_timer: detachable EV_TIMEOUT

feature {EV_ANY, EV_ANY_I} -- Implementation

	implementation: EV_LABEL_I
			-- Responsible for interaction with native graphics toolkit.

end
