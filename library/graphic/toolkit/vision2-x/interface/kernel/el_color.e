note
	description: "Summary description for {EL_EV_COLOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-03 11:26:38 GMT (Monday 3rd June 2013)"
	revision: "2"

class
	EL_COLOR

inherit
	EV_COLOR
		redefine
			rgb_24_bit, set_rgb_with_24_bit
		end

	EL_MODULE_STRING
		undefine
			default_create, out, is_equal, copy
		end

create
	default_create,
	make, make_with_8_bit_rgb, make_with_rgb, make_with_rgb_24_bit, make_with_html

convert
	make ({EV_COLOR}), make_with_rgb_24_bit ({INTEGER}),
	rgb_24_bit: {INTEGER}


feature {NONE} -- Initialization

	make (a_color: EV_COLOR)
		do
			default_create
			implementation.set_with_other (a_color)
		end

	make_with_rgb_24_bit (a_24_bit_rgb: INTEGER)
		do
			default_create
			set_rgb_with_24_bit (a_24_bit_rgb)
		end

	make_with_html (a_html_color: STRING)
		require
			valid_color_string: a_html_color.count = 7 and then a_html_color [1] = '#'
		do
			default_create
			set_rgb_with_24_bit (String.hexadecimal_to_integer (a_html_color.substring (2, a_html_color.count)))
		end

feature -- Access

	rgb_24_bit: INTEGER
		do
			Result := implementation.red_8_bit |<< 16 + implementation.green_8_bit |<< 8 + implementation.blue_8_bit
		end

	html_color: STRING
		do
			Result := rgb_24_bit.to_hex_string
			Result.put ('#', 2)
			Result.remove_head (1)
		end

feature -- Element change

	set_rgb_with_24_bit (a_24_bit_rgb: INTEGER)
		local
			component_8_bit: INTEGER
			i, shifted_24_bit_rgb: INTEGER
		do
			shifted_24_bit_rgb := a_24_bit_rgb
			from i := 3 until i = 0 loop
				component_8_bit := shifted_24_bit_rgb & 0xFF
				inspect i
					when 1 then
						implementation.set_red_with_8_bit (component_8_bit)
					when 2 then
						implementation.set_green_with_8_bit (component_8_bit)
				else
					implementation.set_blue_with_8_bit (component_8_bit)
				end
				shifted_24_bit_rgb := shifted_24_bit_rgb |>> 8
				i := i - 1
			end
		ensure then
			assigned: rgb_24_bit = a_24_bit_rgb
		end

end
