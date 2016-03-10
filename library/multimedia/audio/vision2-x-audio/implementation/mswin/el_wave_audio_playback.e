note
	description: "Class to help integrate WEX with Vision2"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_WAVE_AUDIO_PLAYBACK

feature -- Access

	wave_device: EL_AUDIO_SEGMENT_PLAYING_DEVICE
			--
		once
			if attached {WEL_COMPOSITE_WINDOW} implementation as wel_window then
				-- Underlying toolkit window
				create Result.make (wel_window)
			end
		ensure
			created_result: Result /= Void
		end

feature -- Basic operations

	close_wave_device
			-- 
		do
			if wave_device.opened then
				wave_device.stop
				wave_device.close
			end
		end

feature {NONE} -- Implementation

	implementation: EV_WIDGET_I
			-- 
		deferred
		end

end
