note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_AUDIO_OUTPUT_DEVICE

inherit
	EL_WINDOWS_AUDIO_API

	EL_MM_SYSTEM_CONSTANTS
		undefine
			io
		end

	EL_MODULE_LOG

create
	make_open

feature {NONE} -- Initialization

	make_open (wave_header: EL_AUDIO_WAVE_HEADER)
			--
		local
			status: INTEGER
		do
			waveform_format := wave_header.to_c_struct
			create device_handle.make (c_size_of_HWAVEOUT)
			status := c_wave_out_open (
				device_handle.item,
				cdef_WAVE_MAPPER,
				waveform_format.item,
				c_wave_out_procedure,
				Default_pointer,
				cdef_CALLBACK_FUNCTION
			)
			is_open := status = cdef_MMSYSERR_NOERROR
		ensure
			is_open: is_open
		end

feature -- Status query

	is_paused: BOOLEAN

	is_open: BOOLEAN

	is_volume_setting_saved: BOOLEAN

feature -- Basic operations

	pause
			--
		local
			status: INTEGER
		do
			status := c_wave_out_pause (device_handle.item)
			is_paused := status = cdef_MMSYSERR_NOERROR
			check
				is_paused: is_paused
			end
		end

	restart
			--
		local
			status: INTEGER
		do
			status := c_wave_out_restart (device_handle.item)
			check
				is_restarted: is_paused implies status = cdef_MMSYSERR_NOERROR
			end
			is_paused := false
		end

	reset
			--
		local
			status: INTEGER
		do
			status := c_wave_out_reset (device_handle.item)
			check
				is_reset: status = cdef_MMSYSERR_NOERROR
			end
		end

	close
			--
		local
			status: INTEGER
		do

			from status := cdef_WAVERR_STILLPLAYING until status /= cdef_WAVERR_STILLPLAYING loop
				status := c_wave_out_close (device_handle.item)
				if status = cdef_WAVERR_STILLPLAYING then
					reset
				end
			end
			check
				is_closed: status = cdef_MMSYSERR_NOERROR
			end
		end

	save_volume_setting
			--
		local
			status: INTEGER
		do
			status := c_get_volume (device_handle.item, $volume_setting)
			is_volume_setting_saved := status = cdef_MMSYSERR_NOERROR
		end

	restore_volume_setting
			--
		require
			volume_setting_saved: is_volume_setting_saved
		local
			status: INTEGER
		do
			if is_volume_setting_saved then
				status := c_set_volume (device_handle.item, volume_setting)
				check
					volume_set: status = cdef_MMSYSERR_NOERROR
				end
			end
		end

	set_volume_as_percentage (channel_volume_percent: ARRAY [INTEGER])
			--
		local
			status, ch, volume_word, combined_volume_word: INTEGER
		do
			from ch := 1 until ch > channel_volume_percent.count loop
				volume_word := (Maximum_volume * (channel_volume_percent [ch] / 100)).rounded
				volume_word := volume_word.bit_shift_left (16 * (ch - 1))
				combined_volume_word := combined_volume_word + volume_word
				ch := ch + 1
			end
			status := c_set_volume (device_handle.item, combined_volume_word)
			check
				volume_set: status = cdef_MMSYSERR_NOERROR
			end
		end

feature -- Access

	device_handle: MANAGED_POINTER

	buffers_played_count: INTEGER
			--
		do
			Result := c_buffers_played_count
		end

feature {NONE} -- Implementation

	waveform_format: MANAGED_POINTER

	volume_setting: INTEGER

feature -- Constants

	Maximum_volume: INTEGER = 0xFFFF

invariant

	valid_wave_out_handle: device_handle /= Void

end
