note
	description: "Interface to Java class: `com.eiffel_loop.svg.SVG_TO_PNG_TRANSCODER'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	J_SVG_TO_PNG_TRANSCODER

inherit
	J_OBJECT
		undefine
			Package_name
		redefine
			new_jclass_name
		end

	COM_EIFFEL_LOOP_SVG_JPACKAGE

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

	jagent_transcode: JAVA_PROCEDURE
			-- public void transcode (String input_path, String output_path)
		once
			create Result.make ("transcode", agent transcode)
		end

	jagent_set_width: JAVA_PROCEDURE
			-- public void set_width (int width)
		once
			create Result.make ("set_width", agent set_width)
		end

	jagent_set_height: JAVA_PROCEDURE
			-- public void set_height (int height)
		once
			create Result.make ("set_height", agent set_height)
		end

	jagent_set_background_color_with_24_bit_rgb: JAVA_PROCEDURE
			-- public void set_background_color_with_24_bit_rgb (int rgb_24_bit)
		once
			create Result.make ("set_background_color_with_24_bit_rgb", agent set_background_color_with_24_bit_rgb)
		end

	new_jclass_name: STRING
		-- use Eiffel class naming convention
		do
			Result := Naming.class_as_snake_upper (Current, 1, 0)
		end

end