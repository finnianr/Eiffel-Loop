note
	description: "[
		Thread consumer for audio clips taken from a (thread product) work queue.
		Saves the clips in the temp directory with unique file names and puts the saved file path
		onto a (thread product) work queue for processing by another thread.
		Notifies a sound level listener of any audio clips which are silent (below the noise threshold)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:00 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_AUDIO_CLIP_SAVER

inherit
	EL_CONSUMER_THREAD [EL_WAVE_AUDIO_16_BIT_CLIP]
		rename
			make as make_consumer,
			consume_product as save_clip,
			product as audio_clip
		redefine
			Is_visible_in_console
		end

	EL_AUDIO_CLIP_SAVER_CONSTANTS
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_LOG
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_PATH
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
			File_system.delete (Previous_samples_wildcard)
			create sample_count
		end

feature -- Access

	audio_file_processing_queue: EL_THREAD_PRODUCT_QUEUE [STRING]

	samples_recorded_count: INTEGER
			--
		do
			sample_count.lock
--			synchronized
				Result := sample_count.item
--			end
			sample_count.unlock
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
			sample_count.lock
--			synchronized
				sample_count.item.set_item (0)
--			end
			sample_count.unlock
		end

	set_signal_threshold (rms_energy: REAL)
			--
		do
			noise_threshold := rms_energy
		end

feature -- Status query

	Is_visible_in_console: BOOLEAN = True
			-- is logging output visible in console

feature {NONE} -- Implementation

	save_clip
			--
		local
			clip_name: STRING
			audio_rms_energy: REAL
		do
 			audio_rms_energy := audio_clip.rms_energy

			if sound_level_listener /= Void then
				sound_level_listener.set_signal_level (audio_rms_energy)
			end

			sample_count.lock
--			synchronized
				sample_count.item.set_item (sample_count.item.item + audio_clip.sample_count)
--			end
			sample_count.unlock

			if audio_rms_energy > noise_threshold then
				log.enter ("save_clip")
				clip_count := clip_count + 1
				clip_name := unique_clip_name (clip_count)

				audio_clip.save (File.joined_path (Path.temp_directory_path, clip_name))

				log.put_string_field ("File name", clip_name)
				log.put_new_line

				audio_file_processing_queue.put (clip_name)
				log.exit
			else
				audio_file_processing_queue.put (Silent_clip_name)
			end
		end

	unique_clip_name (n: INTEGER): STRING
			--
		local
			n_string: STRING
		do
			create Result.make_from_string (Clip_base_name)

			n_string := (n + Clip_no_base).out
			n_string.remove_head (1)

			Result.append ("-")
			Result.append (n_string)
			Result.append (".wav")

		end

	clip_count: INTEGER

	sound_level_listener: EL_SIGNAL_LEVEL_LISTENER

	sample_count: EL_SYNCHRONIZED [INTEGER_REF]

	noise_threshold: REAL

feature -- Constants

	Previous_samples_wildcard: EL_FILE_PATH
			--
		once ("PROCESS")
			Result := File.joined_path (Path.temp_directory_path, Clip_base_name + "*.wav" )
		end

end




