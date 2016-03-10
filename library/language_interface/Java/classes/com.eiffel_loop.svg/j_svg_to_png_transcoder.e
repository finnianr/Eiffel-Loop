note
	description: "Summary description for {J_SVG_TO_PNG_TRANSCODER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	J_SVG_TO_PNG_TRANSCODER

inherit
	COM_EIFFEL_LOOP_SVG_JPACKAGE

	J_OBJECT
		undefine
			Package_name, Jclass
		end

create
	make

feature -- Element change

	set_width (a_width: J_INT)
			--
		do
			jagent_set_width.call (Current, [a_width])
		end

	set_height (a_height: J_INT)
			--
		do
			jagent_set_height.call (Current, [a_height])
		end

	set_background_color_with_24_bit_rgb (rgb_24_bit: J_INT)
		do
			jagent_set_background_color_with_24_bit_rgb.call (Current, [rgb_24_bit])
		end

feature -- Basic operations

	transcode (input_file_path, output_file_path: J_STRING)
			--
		do
			jagent_transcode.call (Current, [input_file_path, output_file_path])
		end

feature {NONE} -- Implementation

	jagent_transcode: JAVA_PROCEDURE [J_SVG_TO_PNG_TRANSCODER]
			-- public void transcode (String input_path, String output_path)
		once
			create Result.make ("transcode", agent transcode)
		end

	jagent_set_width: JAVA_PROCEDURE [J_SVG_TO_PNG_TRANSCODER]
			-- public void set_width (int width)
		once
			create Result.make ("set_width", agent set_width)
		end

	jagent_set_height: JAVA_PROCEDURE [J_SVG_TO_PNG_TRANSCODER]
			-- public void set_height (int height)
		once
			create Result.make ("set_height", agent set_height)
		end

	jagent_set_background_color_with_24_bit_rgb: JAVA_PROCEDURE [J_SVG_TO_PNG_TRANSCODER]
			-- public void set_background_color_with_24_bit_rgb (int rgb_24_bit)
		once
			create Result.make ("set_background_color_with_24_bit_rgb", agent set_background_color_with_24_bit_rgb)
		end

feature {NONE} -- Constant

	Jclass: JAVA_CLASS_REFERENCE
			--
		once
			create Result.make (Package_name, "SVG_TO_PNG_TRANSCODER")
		end

end
