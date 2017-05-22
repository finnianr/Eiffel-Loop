note
	description: "[
		Thread consumer for audio clips taken from a (thread product) work queue.
		Saves the clips in the temp directory with unique file names and puts the saved file path
		onto a (thread product) work queue for processing by another thread.
		Notifies a sound level listener of any audio clips which are silent (below the noise threshold)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "1"

class
	EL_AUDIO_CLIP_SAVER

inherit
	EL_CONSUMER_THREAD [EL_WAVE_AUDIO_16_BIT_CLIP]
		rename
			make as make_consumer,
			consume_product as save_clip,
			product as audio_clip
		redefine
			on_start
		end

	EL_AUDIO_CLIP_SAVER_CONSTANTS
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_LOG
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_LOG_MANAGER
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_DIRECTORY
		undefine
			default_create, is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make (rms_energy: REAL)
			--
		do
			make_consumer
			noise_threshold := rms_energy
			create audio_file_processing_queue.make
			log.put_new_line

			across Temporary_directory.files_with_extension ("wav") as wav_path loop
				if wav_path.item.base.starts_with (Clip_base_name) then
					File_system.remove_file (wav_path.item)
				end
			end
			create sample_count
		end

feature -- Access

	audio_file_processing_queue: EL_THREAD_PRODUCT_QUEUE [STRING]

	samples_recorded_count: INTEGER
			--
		do
			Result := sample_count.value
		end

feature -- Element change

	set_sound_level_listener (a_sound_level_listener: EL_SIGNAL_LEVEL_LISTENER)
			--
		require
			a_sound_level_listener_not_void: a_sound_level_listener /= Void
		do
			sound_level_listener := a_sound_level_listener
		end

	reset_sample_count
			--
		do
			sample_count.set_value (0)
		end

	set_signal_threshold (rms_energy: REAL)
			--
		do
			noise_threshold := rms_energy
		end

feature {NONE} -- Implementation

	save_clip
			--
		local
			clip_name: ZSTRING; audio_rms_energy: REAL
		do
 			audio_rms_energy := audio_clip.rms_energy

			if sound_level_listener /= Void then
				sound_level_listener.set_signal_level (audio_rms_energy)
			end

			sample_count.add (audio_clip.sample_count)

			if audio_rms_energy > noise_threshold then
				log.enter ("save_clip")
				clip_count := clip_count + 1
				clip_name := unique_clip_name (clip_count)

				audio_clip.save (Directory.temporary + clip_name)

				log.put_string_field ("File name", clip_name)
				log.put_new_line

				audio_file_processing_queue.put (clip_name)
				log.exit
			else
				audio_file_processing_queue.put (Silent_clip_name)
			end
		end

	on_start
		do
			Log_manager.add_thread (Current)
		end

	unique_clip_name (n: INTEGER): ZSTRING
			--
		local
			n_string: STRING
		do
			Result := Clip_base_name.twin

			n_string := (n + Clip_no_base).out
			n_string.remove_head (1)

			Result.append_all_general (<< "-", n_string, ".wav" >>)

		end

feature {NONE} -- Internal attributes

	clip_count: INTEGER

	sound_level_listener: EL_SIGNAL_LEVEL_LISTENER

	sample_count: EL_MUTEX_NUMERIC [INTEGER]

	noise_threshold: REAL

feature -- Constants

	Temporary_directory: EL_DIRECTORY
			--
		once
			create Result.make (Directory.temporary)
		end

end



