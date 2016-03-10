note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_AUDIO_SIGNAL_LEVEL_METER

inherit
	WEL_PROGRESS_BAR
		rename
			set_position as set_position_immediately
		end

	EL_SIGNAL_LEVEL_LISTENER

	EL_MODULE_LOG

create
	make

feature -- Element change

	set_signal_threshold (rms_energy: REAL)
			--
		do
			signal_threshold := rms_energy
		end

	set_signal_level (rms_energy: REAL)
			--
		local
			level, new_level: INTEGER
		do
			log.enter_no_header ("set_signal_level")
			level := (rms_energy * 4 * maximum).rounded
 			if level <= maximum then
 				new_level := level
 			else
 				new_level := maximum
 			end
			if rms_energy <= signal_threshold then
				new_level := 0
			else
				log.put_integer_field ("Signal level (root mean square)", new_level)
				log.put_new_line
			end
			set_position (new_level)
			log.exit_no_trailer
		end

feature {NONE} -- Implementation

	signal_threshold: REAL

	set_position (new_position: INTEGER)
			-- Set the current position with `new_position'.
 			-- Use cwin_post_message instead of cwin_send_message so it can safely be called from
 			-- a thread separate from the window thread
		do
			cwin_post_message (item, Pbm_setpos, to_wparam (new_position), to_lparam (0))
		end

end




