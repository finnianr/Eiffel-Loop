note
	description: "Summary description for {EL_EV_INTERNAL_SILLY_WINDOW_IMP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_INTERNAL_EVENT_EMITTER_WINDOW_IMP

inherit
	EV_INTERNAL_SILLY_WINDOW_IMP
		redefine
			default_process_message, make_top
		end

	EL_EVENT_EMITTER
		rename
			make as make_emitter
		end

create
	make_top

feature {NONE} -- Initialization

	make_top (a_name: detachable READABLE_STRING_GENERAL)
		do
			Precursor (a_name)
			make_emitter
		end

feature -- Basic operations

	generate (index: INTEGER)
			--
		do
			{WEL_API}.post_message (item, Wm_generic_event, to_wparam (index), to_lparam (0))
		end

feature {NONE} -- Implementation

	default_process_message (msg: INTEGER; wparam, lparam: POINTER)
			-- Process `msg' which has not been processed by
			-- `process_message'.
		do
			if msg = Wm_generic_event then
				listener.on_event (wparam.to_integer_32)
			else
				Precursor (msg, wparam, lparam)
			end
		end

feature {EL_APPLICATION_IMP} -- Constants

	Wm_generic_event: INTEGER
			--
		once
			Result := Wm_user + 10
		end

end
