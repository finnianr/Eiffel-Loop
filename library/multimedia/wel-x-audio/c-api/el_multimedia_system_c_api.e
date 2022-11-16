note
	description: "[
		[https://docs.microsoft.com/en-us/windows/win32/multimedia/windows-multimedia-start-page?redirectedfrom=MSDN
		Microsoft Windows multimedia support]
		
			#include <mmsystem.h>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_MULTIMEDIA_SYSTEM_C_API

inherit
	EL_C_API

feature {NONE} -- C externals

	c_wave_out_open (
			-- Pointer to a buffer that receives a handle identifying the open waveform-audio output device.
		device_handle_ptr: POINTER;

			-- Identifier of the waveform-audio output device to open.
		device_id: INTEGER;

			-- Pointer to a WAVEFORMATEX structure that identifies the desired format
			-- for recording waveform-audio data.
		pwfx: POINTER

			-- Pointer to a fixed callback function, an event handle, a handle to a window
		dwCallback: POINTER

			-- User-instance data passed to the callback mechanism.
		dwCallbackInstance: POINTER;

			-- Flags for opening the device.
		flags: INTEGER

	): INTEGER
			-- Opens the given waveform-audio output device for recording

			--| waveOutOpen( OUT LPHWAVEOUT phwi, IN UINT uDeviceID,
		    --|				IN LPCWAVEFORMATEX pwfx, IN DWORD_PTR dwCallback,
		    --|				IN DWORD_PTR dwCallbackInstance, IN DWORD fdwOpen)
		external
			"C [macro <mmsystem.h>] (LPHWAVEOUT, UINT, LPCWAVEFORMATEX, DWORD_PTR, DWORD_PTR, DWORD): EIF_INTEGER"
		alias
			"waveOutOpen"
		end

	c_wave_out_restart (
		device_handle_ptr: POINTER
			-- handle identifying the open waveform-audio output device
	): INTEGER
			-- MMRESULT waveOutRestart (HWAVEIN hwi)
		external
			"C inline use <mmsystem.h>"
		alias
			"waveOutRestart (*(LPHWAVEOUT) $device_handle_ptr)"
		end

	c_wave_out_pause (
		device_handle_ptr: POINTER
			-- handle identifying the open waveform-audio output device
	): INTEGER
			-- MMRESULT waveOutPause (HWAVEIN hwi)
		external
			"C inline use <mmsystem.h>"
		alias
			"waveOutPause (*(LPHWAVEOUT) $device_handle_ptr)"
		end

	c_wave_out_reset (
		device_handle_ptr: POINTER
			-- handle identifying the open waveform-audio output device
	): INTEGER
			-- Stops input on the given waveform-audio output device and resets the current position to zero.
			-- All pending buffers are marked as done and returned to the application.

			--| MMRESULT waveOutStart(HWAVEIN hwi)
		external
			"C inline use <mmsystem.h>"
		alias
			"waveOutReset (*(LPHWAVEOUT) $device_handle_ptr)"
		end

	c_wave_out_close (
		device_handle_ptr: POINTER
			-- handle identifying the open waveform-audio output device
	): INTEGER
			-- closes the given waveform-audio output device

			--| MMRESULT waveOutStart(HWAVEIN hwi)
		external
			"C inline use <mmsystem.h>"
		alias
			"waveOutClose (*(LPHWAVEOUT) $device_handle_ptr)"
		end

	c_wave_out_procedure: POINTER
			--
		external
			"C inline use <eiffel_loop_audio.h>"
		alias
			"waveOutProc"
		end

	c_buffers_played_count: INTEGER
			--
		external
			"C inline use <eiffel_loop_audio.h>"
		alias
			"buffers_played_count"
		end

	c_size_of_HWAVEOUT: INTEGER
			--
		external
			"C [macro <mmsystem.h>]"
		alias
			"sizeof (HWAVEOUT)"
		end

	c_set_volume (device_handle_ptr: POINTER; combined_channel_volume_setting: INTEGER): INTEGER
			-- sets the volume level of the specified waveform-audio  output device.
			-- MMRESULT waveOutSetVolume(HWAVEOUT hwo, DWORD dwVolume )
			--
		external
			"C inline use <mmsystem.h>"
		alias
			"waveOutSetVolume (*(LPHWAVEOUT) $device_handle_ptr, (DWORD)$combined_channel_volume_setting)"
		end


	c_get_volume (device_handle_ptr: POINTER; ptr_to_combined_channel_volume_integer: POINTER): INTEGER
			-- MMRESULT waveOutGetVolume (HWAVEOUT hwo, LPDWORD pdwVolume);

			-- Parameter: hwo
			-- 		Handle to an open waveform-audio output device. This parameter can also be a device identifier.

			-- Parameter: pdwVolume
			-- 		Pointer to a variable to be filled with the current volume setting. The low-order word of this location
			--		contains the left-channel volume setting, and the high-order word contains the right-channel setting.
			-- 		A value of 0xFFFF represents full volume, and a value of 0x0000 is silence.

			-- 		If a device does not support both left and right volume control, the low-order word of the specified
			--		location contains the mono volume level.
		external
			"C inline use <mmsystem.h>"
		alias
			"waveOutGetVolume (*(LPHWAVEOUT) $device_handle_ptr, (LPDWORD)$ptr_to_combined_channel_volume_integer)"
		end

	c_size_of_WAVEHDR: INTEGER
			--
		external
			"C [macro <mmsystem.h>]"
		alias
			"sizeof (WAVEHDR)"
		end

	c_set_data (p: POINTER; data_ptr: POINTER)
			--
		external
			"C [struct <mmsystem.h>] (WAVEHDR, LPSTR)"
		alias
			"lpData"
		end

	c_set_buffer_length (p: POINTER; length: INTEGER)
			--
		external
			"C [struct <mmsystem.h>] (WAVEHDR, DWORD)"
		alias
			"dwBufferLength"
		end

	c_dw_flags (p: POINTER): INTEGER
			--
		external
			"C [struct <mmsystem.h>] (WAVEHDR): EIF_INTEGER"
		alias
			"dwFlags"
		end

	c_wave_out_prepare_header (
		device_handle_ptr: POINTER;
			-- handle identifying the open waveform-audio output device

		wave_header: POINTER;
			-- Pointer to WAVEHDR struct

	): INTEGER
			-- MMRESULT waveOutPrepareHeader(HWAVEOUT hwo, LPWAVEHDR pwh, UINT cbwh)
		external
			"C inline use <mmsystem.h>"
		alias
			"waveOutPrepareHeader (*(LPHWAVEOUT) $device_handle_ptr, (LPWAVEHDR) $wave_header, (UINT) sizeof (WAVEHDR))"
		end

	c_wave_out_unprepare_header (
		device_handle_ptr: POINTER;
			-- handle identifying the open waveform-audio output device

		wave_header: POINTER;
			-- Pointer to WAVEHDR struct

	): INTEGER
			-- MMRESULT waveOutUnprepareHeader(HWAVEOUT hwo, LPWAVEHDR pwh, UINT cbwh)
		external
			"C inline use <mmsystem.h>"
		alias
			"waveOutUnprepareHeader (*(LPHWAVEOUT) $device_handle_ptr, (LPWAVEHDR) $wave_header, (UINT) sizeof (WAVEHDR))"
		end

	c_wave_out_write (
		device_handle_ptr: POINTER;
			-- handle identifying the open waveform-audio input device

		wave_header: POINTER;
			-- Pointer to WAVEHDR struct

	): INTEGER
			-- MMRESULT waveOutWrite(HWAVEOUT hwo,  LPWAVEHDR pwh, UINT cbwh );
		external
			"C inline use <mmsystem.h>"
		alias
			"waveOutWrite (*(LPHWAVEOUT) $device_handle_ptr, (LPWAVEHDR) $wave_header, (UINT) sizeof (WAVEHDR))"
		end

feature {NONE} -- Access WAVEFORMATEX

	c_size_of_wave_formatex: INTEGER
			--
		external
			"C [macro <mmsystem.h>]"
		alias
			"sizeof (WAVEFORMATEX)"
		end

	c_format (p: POINTER): INTEGER
			--
		external
			"C [struct <mmsystem.h>] (WAVEFORMATEX): EIF_INTEGER"
		alias
			"wFormatTag"
		end

	c_num_channels (p: POINTER): INTEGER
			--
		external
			"C [struct <mmsystem.h>] (WAVEFORMATEX): EIF_INTEGER"
		alias
			"nChannels"
		end

	c_bits_per_sample (p: POINTER): INTEGER
			--
		external
			"C [struct <mmsystem.h>] (WAVEFORMATEX): EIF_INTEGER"
		alias
			"wBitsPerSample"
		end

	c_samples_per_sec (p: POINTER): INTEGER
			--
		external
			"C [struct <mmsystem.h>] (WAVEFORMATEX): EIF_INTEGER"
		alias
			"nSamplesPerSec"
		end

	c_block_align (p: POINTER): INTEGER
			--
		external
			"C [struct <mmsystem.h>] (WAVEFORMATEX): EIF_INTEGER"
		alias
			"nBlockAlign"
		end

	c_average_bytes_per_sec (p: POINTER): INTEGER
			--
		external
			"C [struct <mmsystem.h>] (WAVEFORMATEX): EIF_INTEGER"
		alias
			"nAvgBytesPerSec"
		end

feature {NONE} -- Element change WAVEFORMATEX

	c_set_format (p: POINTER; a_format: INTEGER)
			--
		external
			"C [struct <mmsystem.h>] (WAVEFORMATEX, WORD)"
		alias
			"wFormatTag"
		end

	c_set_num_channels (p: POINTER; number: INTEGER)
			--
		external
			"C [struct <mmsystem.h>] (WAVEFORMATEX, WORD)"
		alias
			"nChannels"
		end

	c_set_samples_per_sec (p: POINTER; samples_per_sec_count: INTEGER)
			--
		external
			"C [struct <mmsystem.h>] (WAVEFORMATEX, DWORD)"
		alias
			"nSamplesPerSec"
		end

	c_set_bits_per_sample (p: POINTER; bits: INTEGER)
			--
		external
			"C [struct <mmsystem.h>] (WAVEFORMATEX, WORD)"
		alias
			"wBitsPerSample"
		end

	c_set_cb_size (p: POINTER; size_byte_count: INTEGER)
		-- Size, in bytes, of extra format information appended to the end of the WAVEFORMATEX structure.
		-- This information can be used by non-PCM formats to store extra attributes for the wFormatTag.
		-- If no extra information is required by the wFormatTag, this member must be set to 0.
		-- For WAVE_FORMAT_PCM formats (and only WAVE_FORMAT_PCM formats), this member is ignored.
		-- When this structure is included in a WAVEFORMATEXTENSIBLE structure, this value must be at least 22.

		external
			"C [struct <mmsystem.h>] (WAVEFORMATEX, WORD)"
		alias
			"cbSize"
		end

	c_set_block_align (p: POINTER; a_block_align: INTEGER)
			--
		external
			"C [struct <mmsystem.h>] (WAVEFORMATEX, WORD)"
		alias
			"nBlockAlign"
		end

	c_set_average_bytes_per_sec (p: POINTER; bytes_per_sec: INTEGER)
			--
		external
			"C [struct <mmsystem.h>] (WAVEFORMATEX, DWORD)"
		alias
			"nAvgBytesPerSec"
		end

feature -- Access

	MM_sys_err_noerror: INTEGER
			--
		once
			Result := cdef_mmsyserr_noerror
		end

	Wave_mapper: INTEGER
			--
		once
			Result := cdef_wave_mapper
		end

	Callback_window: INTEGER
			--
		once
			Result := cdef_callback_window
		end

	MM_wim_data: INTEGER
			--
		once
			Result := cdef_mm_wim_data
		end

	MM_wim_open: INTEGER
			--
		once
			Result := cdef_mm_wim_open
		end

	MM_wim_close: INTEGER
			--
		once
			Result := cdef_mm_wim_close
		end

feature {NONE} -- Implementation

	cdef_MM_WIM_DATA: INTEGER
			-- received waveform input data
		external
			"C [macro <mmsystem.h>]"
		alias
			"MM_WIM_DATA"
		end

	cdef_MM_WIM_OPEN: INTEGER
			-- waveform input opened
		external
			"C [macro <mmsystem.h>]"
		alias
			"MM_WIM_OPEN"
		end

	cdef_MM_WIM_CLOSE: INTEGER
			-- waveform input closes
		external
			"C [macro <mmsystem.h>]"
		alias
			"MM_WIM_CLOSE"
		end

	cdef_WHDR_PREPARED: INTEGER
			-- set if this header has been prepared
		external
			"C [macro <mmsystem.h>]"
		alias
			"WHDR_PREPARED"
		end

	cdef_WHDR_DONE: INTEGER
			-- set if this header has been prepared
		external
			"C [macro <mmsystem.h>]"
		alias
			"WHDR_DONE"
		end

	cdef_WAVE_MAPPER: INTEGER
			--
		external
			"C [macro <mmsystem.h>]"
		alias
			"WAVE_MAPPER"
		end

	cdef_CALLBACK_WINDOW: INTEGER
			--
		external
			"C [macro <mmsystem.h>]"
		alias
			"CALLBACK_WINDOW"
		end

	cdef_CALLBACK_FUNCTION: INTEGER
			--
		external
			"C [macro <mmsystem.h>]"
		alias
			"CALLBACK_FUNCTION"
		end

	cdef_WAVE_FORMAT_PCM: INTEGER
			--
		external
			"C [macro <mmsystem.h>]"
		alias
			"WAVE_FORMAT_PCM"
		end

feature -- Error codes

	cdef_MMSYSERR_NOERROR: INTEGER
			--
		external
			"C [macro <mmsystem.h>]"
		alias
			"MMSYSERR_NOERROR"
		end

	cdef_WAVERR_STILLPLAYING: INTEGER
			--
		external
			"C [macro <mmsystem.h>]"
		alias
			"WAVERR_STILLPLAYING"
		end

	cdef_MMSYSERR_INVALHANDLE: INTEGER
			-- device ID for wave device mapper
		external
			"C [macro <mmsystem.h>]"
		alias
			"MMSYSERR_INVALHANDLE"
		end

	cdef_MMSYSERR_NODRIVER: INTEGER
			-- device ID for wave device mapper
		external
			"C [macro <mmsystem.h>]"
		alias
			"MMSYSERR_NODRIVER"
		end

	cdef_MMSYSERR_NOMEM: INTEGER
			-- device ID for wave device mapper
		external
			"C [macro <mmsystem.h>]"
		alias
			"MMSYSERR_NOMEM"
		end

end