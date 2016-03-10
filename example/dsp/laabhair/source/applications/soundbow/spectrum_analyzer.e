indexing
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	SPECTRUM_ANALYZER

inherit
	LB_AUDIO_CLIP_ANALYZER
		redefine
			make, set_praat_script_variables
		end
		
	SOUNDBOW_SHARED_CONFIGURATION
	
	DOUBLE_MATH
		rename
			log as logarithm
		export
			{NONE} all
		end
	
create
	make

feature {NONE} -- Initialization

	make (flash_remote_procedure_invoker: like Result_consumer_type) is
			--
		do
			Precursor (flash_remote_procedure_invoker)
			
			create flash_spectrum_visualizer.make (flash_RPC_request_queue)
			create tone_index_and_color_intensity_array.make (30)
			
			set_sound_energy_to_color_intensity_ratio
			create_sound_visualizer
			
			Config.register_change_action (
				<< Config.sound_energy_to_color_intensity_ratio >>, agent set_sound_energy_to_color_intensity_ratio
			)
			Config.register_change_action (
				<< 	Config.num_octaves,
					Config.base_frequency,
					Config.num_microtones_per_color_transition
					
				>>, agent create_sound_visualizer
			)
			Config.register_change_action (
				<< Config.script_file_name >>, agent set_praat_script
			)
		end

feature {NONE} -- Element change

	set_praat_script is
			--
		do
			set_praat_script_from_file (Config.script_file_name.item)
		end

	set_sound_energy_to_color_intensity_ratio is
			--
		do
			log.enter ("set_sound_energy_to_color_intensity_ratio")
			sound_energy_to_color_intensity_ratio := Config.sound_energy_to_color_intensity_ratio.item
			log.put_real_field (
				"sound_energy_to_color_intensity_ratio", sound_energy_to_color_intensity_ratio
			)
			log.put_new_line
			log.exit
		end
		
	create_sound_visualizer is
			--
		local
			flash_root: FLASH_ROOT_PROXY
		do
			log.enter ("create_sound_visualizer")
			num_octaves := Config.num_octaves.item
			base_frequency := Config.base_frequency.item
			num_microtones_per_color_transition := Config.num_microtones_per_color_transition.item
			
			num_microtones_per_octave := Num_color_transitions_in_spectrum * num_microtones_per_color_transition
			microtone_interval_ratio := 10 ^ (log10 (2) / num_microtones_per_octave)
	
			create_praat_energy_band_names
			
			create flash_root.make (flash_RPC_request_queue)
			flash_root.create_sound_visualizer (base_frequency, num_octaves, num_microtones_per_color_transition)
			log.exit
		end

feature {NONE} -- Implementation
	
	set_praat_script_variables is
			--
		do
			Precursor
			-- Note: Praat does not allow variable names that start with uppercase
			praat_assign_double ("num_octaves", num_octaves)
			praat_assign_double ("num_microtones_per_octave", num_microtones_per_octave)
			praat_assign_double ("octave_base_freq", base_frequency)
			praat_assign_double ("microtone_interval_ratio", microtone_interval_ratio)
		end

	Default_praat_script: STRING is "[
	
		Read from file... 'audio_file_path$'
		sound$ = selected$ ("Sound")
		
		To Spectrum... (fft)
		select Spectrum 'sound$'
		
		for octave from 1 to num_octaves
			tone_frequency_lower = octave_base_freq

			for microtone from 1 to num_microtones_per_octave
				tone_frequency_upper = tone_frequency_lower * microtone_interval_ratio
				o'octave'_m'microtone' = Get band energy... tone_frequency_lower tone_frequency_upper
				tone_frequency_lower = tone_frequency_upper
			endfor
			octave_base_freq = octave_base_freq * 2
		endfor
		
		select all
		Remove
		
	]"
	
	on_script_executed (script_ctx: EL_PRAAT_SCRIPT_CONTEXT) is
			--
		local
			microtone_zero_index, octave, microtone: INTEGER
			tone_index_and_color_intensity: ARRAY [NUMERIC]

			sound_energy: REAL -- Pascals^2 / sec
			color_intensity_range: INTEGER_INTERVAL
			color_intensity, activated_tone_count: INTEGER
			energy_band_name: STRING
		do
			log.enter ("on_script_executed")
			tone_index_and_color_intensity_array.wipe_out

			from octave := 1 until octave > num_octaves loop

				from microtone := 1 until microtone > num_microtones_per_octave	loop
					energy_band_name := praat_energy_band_names.item (octave).item (microtone)
					sound_energy := script_ctx.real_variable (energy_band_name)

					color_intensity := (sound_energy * 1.0E5 * sound_energy_to_color_intensity_ratio).rounded

					if color_intensity_range = Void then
						create color_intensity_range.make (color_intensity, color_intensity)

					elseif not color_intensity_range.has (color_intensity) then
						color_intensity_range.resize (color_intensity, color_intensity)
					end
					
					if color_intensity > Color_intensity_limits.lower then
						create tone_index_and_color_intensity.make (1, 2)
						microtone_zero_index := (octave - 1) * num_microtones_per_octave + microtone - 1

						tone_index_and_color_intensity [1] := microtone_zero_index
						tone_index_and_color_intensity [2] := color_intensity.min (Color_intensity_limits.upper)

						tone_index_and_color_intensity_array.extend (tone_index_and_color_intensity)
						activated_tone_count := activated_tone_count + 1
					end
					microtone := microtone + 1
				end
				octave := octave + 1
			end
			flash_spectrum_visualizer.ping_microtone_colors (tone_index_and_color_intensity_array)

			log.put_integer_field ("Tones activated", activated_tone_count)
			log.put_integer_field (" Intensity range", color_intensity_range.lower)
			log.put_string (" to ")
			log.put_integer (color_intensity_range.upper)
			log.put_new_line
			log.exit
		end

	flash_spectrum_visualizer: SOUND_SPECTRUM_VISUALIZER_PROXY
	
	tone_index_and_color_intensity_array: ARRAYED_LIST [ARRAY [NUMERIC]]
	
	create_praat_energy_band_names  is
			-- Creates Praat variable names to match the ones created with the Praat script line:
			
			-- o'octave'_m'microtone' = Get band energy... tone_frequency_lower tone_frequency_upper
			
		local
			octave, microtone: INTEGER
			praat_microtone_names: ARRAY [STRING]
			praat_energy_band_name: STRING
		do
			create praat_energy_band_names.make (1, num_octaves)
			from octave := 1 until octave > num_octaves loop
				create praat_microtone_names.make (1, num_microtones_per_octave)
				
				from microtone := 1 until microtone > num_microtones_per_octave loop
					create praat_energy_band_name.make_empty
					praat_energy_band_name.append ("o")		
					praat_energy_band_name.append (octave.out)
					praat_energy_band_name.append ("_m")	
					praat_energy_band_name.append (microtone.out)
		
					praat_microtone_names.put (praat_energy_band_name, microtone)
					microtone := microtone + 1
				end
				praat_energy_band_names.put (praat_microtone_names, octave)
				octave := octave + 1
			end
		end

	praat_energy_band_names: ARRAY [ARRAY [STRING]]
	
	sound_energy_to_color_intensity_ratio: REAL

	num_octaves: INTEGER

	base_frequency: INTEGER
	
	num_microtones_per_color_transition: INTEGER
	
	num_microtones_per_octave: INTEGER
	
	microtone_interval_ratio: DOUBLE
			-- Each microtone pitch is multiplied by this ratio to get the next one
	
feature {NONE} -- Constants

	Num_color_transitions_in_spectrum: INTEGER is 5
			-- 1. red to yellow
			-- 2. yellow to green
			-- 3. green to cyan
			-- 4. cyan to blue
			-- 5. blue to magenta
	
	Color_intensity_limits: INTEGER_INTERVAL is
			-- Maximum and minimum Flash color intensity (alpha value)
		once
			Result := 5 |..| 100
		end
	
end


