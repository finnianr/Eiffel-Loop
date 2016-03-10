note
	description: "Streams audio from microphone"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_AUDIO_INPUT_DEVICE

inherit
	EL_MM_SYSTEM_CONSTANTS
		export
			{NONE} all
		undefine
			io
		end

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make (a_waveform_format: EL_WAVEFORM_FORMAT; clip_duration_millisecs: INTEGER)
			--
		local
			i: INTEGER
		do
			waveform_format := a_waveform_format
			create wave_in_handle.make
			create audio_buffers.make
			from i := 1 until i > Num_audio_buffers loop
				audio_buffers.extend (
					create {EL_WAVE_AUDIO_16_BIT_CLIP}.make (waveform_format, clip_duration_millisecs)
				)
				i := i + 1
			end
		end

feature -- Element change

	set_win_handle (a_win_handle: POINTER)
			--
		do
			win_handle := a_win_handle
		end

feature -- Access

	is_win_handle_valid: BOOLEAN
			--
		do
			Result := is_attached (win_handle)
		end

feature -- Basic operations

	open: INTEGER
			--
		require
			valid_win_handle: is_win_handle_valid
		do
			Result := c_wave_in_open (
				wave_in_handle.item,
				Wave_mapper,
				waveform_format.item,
				win_handle,
				Default_pointer,
				Callback_window
			)
		end

	prepare_headers: INTEGER
			--
		require
			valid_win_handle: is_win_handle_valid
		do
			Result := MM_sys_err_noerror
			from
				audio_buffers.start
			until
				audio_buffers.off or Result /= MM_sys_err_noerror
			loop
				Result := c_wave_in_prepare_header (
					wave_in_handle.item,
					audio_buffers.item.item,
					audio_buffers.first.structure_size
				)
				audio_buffers.forth
			end
		end

	add_buffers: INTEGER
			-- Add buffers for the audio device to fill with audio data
			-- More than one is required in case it is not possible to return it quickly enough to the driver
		require
			valid_win_handle: is_win_handle_valid
		do
			Result := MM_sys_err_noerror
			from
				audio_buffers.start
			until
				audio_buffers.off or Result /= MM_sys_err_noerror
			loop
				Result := c_wave_in_add_buffer (
					wave_in_handle.item,
					audio_buffers.item.item,
					audio_buffers.first.structure_size
				)
				audio_buffers.forth
			end
		end

	requeue_buffer (audio_buffer: POINTER): INTEGER
			-- Requeue this buffer so the driver can use it for another block of audio
		require
			valid_win_handle: is_win_handle_valid
		do
			Result := c_wave_in_add_buffer (
				wave_in_handle.item,
				audio_buffer,
				audio_buffers.first.structure_size
			)
		end

	start: INTEGER
			--
		require
			valid_win_handle: is_win_handle_valid
		do
			Result := c_wave_in_start (wave_in_handle.item)
		end

	reset: INTEGER
			--
		require
			valid_win_handle: is_win_handle_valid
		do
			Result := c_wave_in_reset (wave_in_handle.item)
		end

	close: INTEGER
			--
		require
			valid_win_handle: is_win_handle_valid
		do
			Result := c_wave_in_close (wave_in_handle.item)
			win_handle := Default_pointer
		end

feature {NONE} -- Implementation

	wave_in_handle: EL_WAVE_IN_HANDLE

	waveform_format: EL_WAVEFORM_FORMAT

	audio_buffers: LINKED_LIST [EL_WAVE_AUDIO_16_BIT_CLIP]

	win_handle: POINTER

	Num_audio_buffers: INTEGER = 3

feature {NONE} -- Externals

	c_wave_in_open (
			-- Pointer to a buffer that receives a handle identifying the open waveform-audio input device.
		hwi: POINTER;

			-- Identifier of the waveform-audio input device to open.
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
			-- Opens the given waveform-audio input device for recording

			--| waveInOpen( OUT LPHWAVEIN phwi, IN UINT uDeviceID,
		    --|				IN LPCWAVEFORMATEX pwfx, IN DWORD_PTR dwCallback,
		    --|				IN DWORD_PTR dwCallbackInstance, IN DWORD fdwOpen)
		external
			"C [macro <mmsystem.h>] (LPHWAVEIN, UINT, LPCWAVEFORMATEX, DWORD_PTR, DWORD_PTR, DWORD): EIF_INTEGER"
		alias
			"waveInOpen"
		end

	c_wave_in_prepare_header (
		phwin: POINTER;
			-- handle identifying the open waveform-audio input device

		wave_header: POINTER;
			-- Pointer to WAVEHDR struct

		size: INTEGER
			-- Size of WAVEHDR struct
	): INTEGER
			-- MMRESULT waveInPrepareHeader(HWAVEIN hwi, LPWAVEHDR pwh, UINT cbwh)
		external
			"C inline use <mmsystem.h>"
		alias
			"waveInPrepareHeader  (*(LPHWAVEIN) $phwin, (LPWAVEHDR) $wave_header, (UINT) $size)"
		end

	c_wave_in_add_buffer (
		phwin: POINTER;
			-- handle identifying the open waveform-audio input device

		wave_header: POINTER;
			-- Pointer to WAVEHDR struct

		size: INTEGER
			-- Size of WAVEHDR struct
	): INTEGER
			-- MMRESULT waveInAddBuffer(HWAVEIN hwi, LPWAVEHDR pwh, UINT cbwh)
		external
			"C inline use <mmsystem.h>"
		alias
			"waveInAddBuffer (*(LPHWAVEIN) $phwin, (LPWAVEHDR) $wave_header, (UINT) $size)"
		end

	c_wave_in_start (
		phwin: POINTER
			-- handle identifying the open waveform-audio input device
	): INTEGER
			-- MMRESULT waveInStart (HWAVEIN hwi)
		external
			"C inline use <mmsystem.h>"
		alias
			"waveInStart (*(LPHWAVEIN) $phwin)"
		end

	c_wave_in_reset (
		phwin: POINTER
			-- handle identifying the open waveform-audio input device
	): INTEGER
			-- Stops input on the given waveform-audio input device and resets the current position to zero.
			-- All pending buffers are marked as done and returned to the application.

			--| MMRESULT waveInStart(HWAVEIN hwi)
		external
			"C inline use <mmsystem.h>"
		alias
			"waveInReset (*(LPHWAVEIN) $phwin)"
		end

	c_wave_in_close (
		phwin: POINTER
			-- handle identifying the open waveform-audio input device
	): INTEGER
			-- closes the given waveform-audio input device

			--| MMRESULT waveInStart(HWAVEIN hwi)
		external
			"C inline use <mmsystem.h>"
		alias
			"waveInClose (*(LPHWAVEIN) $phwin)"
		end

invariant

	valid_wave_in_handle: wave_in_handle /= Void
	valid_audio_clip: audio_buffers /= Void
	valid_audio_buffer_structure_size: audio_buffers.first.structure_size /= 0

end


