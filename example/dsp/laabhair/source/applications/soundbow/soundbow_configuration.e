indexing
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	SOUNDBOW_CONFIGURATION

inherit
	LB_BASIC_APP_CONFIGURATION
		redefine
			read_command_line_args, create_editable_fields
		end
		
creation
	make

feature {NONE} -- Initialization

	read_command_line_args is
			--
		do
			Precursor
			set_argument (
				"energy_ratio", sound_energy_to_color_intensity_ratio,
				"[
					Sound energy to color intensity ratio: $VALUE
					  (Change with: -energy_ratio <ratio>)
				]"
			)
			set_argument (
				"octaves", num_octaves,
				"[
					Number of octaves: $VALUE
					  (Change with: -octaves <number of octaves>)
				]"
			)
			set_argument (
				"base", base_frequency,
				"[
					Base frequency (Hz): $VALUE
					  (Change with: -base <freq Hz>)
				]"
			)
			set_argument (
				"microtones", num_microtones_per_color_transition,
				"[
					Number of microtones per color transition (E.g. red to yellow): $VALUE
					  (Change with: -microtones <microtones per color transition>)
				]"
			)
		end

	create_editable_fields is
			--
		do
			Precursor
			create sound_energy_to_color_intensity_ratio.make (
				Current, Default_sound_energy_to_color_intensity_ratio
			)
			add_field (sound_energy_to_color_intensity_ratio)

			create num_octaves.make (Current, Default_num_octaves)
			add_field (num_octaves)
			
			create base_frequency.make (Current, Default_base_frequency)
			add_field (base_frequency)
			
			create num_microtones_per_color_transition.make (Current, Default_num_microtones_per_color_transition)
			add_field (num_microtones_per_color_transition)
		end

feature -- Access

	sound_energy_to_color_intensity_ratio: EL_EDITABLE_REAL
	
	num_octaves: EL_EDITABLE_INTEGER

	base_frequency: EL_EDITABLE_INTEGER

	num_microtones_per_color_transition: EL_EDITABLE_INTEGER

feature -- Default values

	Default_sample_interval_millisecs: INTEGER is 100

	Default_signal_threshold: REAL is 0.005
	
	Default_sound_energy_to_color_intensity_ratio: REAL is 4.5

	Default_num_octaves: INTEGER is 4

	Default_base_frequency: INTEGER is 110

	Default_num_microtones_per_color_transition: INTEGER is 10

end


