indexing
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	SOUNDBOW_CONFIGURATION_EDIT_WINDOW

inherit
	LB_BASIC_CONFIG_EDIT_DIALOG
		redefine
			add_fields
		end
		
	SOUNDBOW_SHARED_CONFIGURATION
	
create
	make_child

feature {NONE} -- Initialization

	add_fields is
			--
		do
			Precursor
			add_real_field (
				"[
					Sound energy to color intensity ratio
					(energy in pascals^2/sec X 100,000 X this ratio
					  = a color alpha value)
				]", Config.sound_energy_to_color_intensity_ratio
			)
			add_integer_field ("Number of octaves", Config.num_octaves)

			add_integer_field ("Base frequency (Hz)", Config.base_frequency)
			
			add_integer_field (
				"[
					Number of microtones per color transition.
					For example red to yellow. (Multiply by 5
					to get microtones per octave)
				]",
				Config.num_microtones_per_color_transition
			)
		end

end


