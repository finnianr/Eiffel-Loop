note
	description: "Color"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-01 18:09:47 GMT (Thursday 1st December 2022)"
	revision: "12"

class
	EL_COLOR

inherit
	EV_COLOR
		redefine
			rgb_24_bit, set_rgb_with_24_bit
		end

create
	default_create,
	make, make_with_8_bit_rgb, make_with_rgb, make_with_rgb_24_bit, make_with_rgb_32_bit,
	make_with_html, make_transparent

convert
	make ({EV_COLOR}), make_with_rgb_24_bit ({INTEGER}), make_with_html ({STRING}),
	rgb_24_bit: {INTEGER}

feature {NONE} -- Initialization

	make (a_color: EV_COLOR)
		do
			make_with_rgb_24_bit (a_color.rgb_24_bit)
		end

	make_transparent
		do
			default_create
			is_transparent := True
		end

	make_with_html (color_code: STRING)
		require
			valid_color_string: color_code.count = 7 and then color_code [1] = '#'
		do
			default_create
			set_with_html (color_code)
		end

	make_with_rgb_24_bit (a_24_bit_rgb: INTEGER)
		do
			default_create
			set_rgb_with_24_bit (a_24_bit_rgb)
		end

	make_with_rgb_32_bit (a_32_bit_rgb: INTEGER)
		do
			default_create
			set_rgb_with_32_bit (a_32_bit_rgb)
		end

feature -- Access

	html_color: STRING
		do
			Result := rgb_24_bit.to_hex_string
			Result.put ('#', 2)
			Result.remove_head (1)
		end

	rgb_24_bit: INTEGER
		do
			Result := implementation.red_8_bit |<< 16 + implementation.green_8_bit |<< 8 + implementation.blue_8_bit
		end

	rgb_32_bit: INTEGER
		do
			if is_transparent then
				Result := Transparent_color_32_bit
			else
				Result := rgb_24_bit
			end
		end

feature -- Conversion

	to_color: EV_COLOR
		do
			create Result.make_with_rgb (red, green, blue)
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

	set_rgb_with_32_bit (a_rgb_32_bit: like rgb_32_bit)
		do
			if a_rgb_32_bit < 0 then
				set_rgb_with_24_bit (0)
				is_transparent := True
			else
				set_rgb_with_24_bit (a_rgb_32_bit)
			end
		end

	set_with_html (color_code: STRING)
		require
			valid_color_string: color_code.count = 7 and then color_code [1] = '#'
		local
			hex: EL_HEXADECIMAL_STRING_CONVERSION
		do
			set_rgb_with_24_bit (hex.to_integer (color_code.substring (2, color_code.count)))
		end

feature -- Status query

	is_transparent: BOOLEAN

feature {NONE} -- Constants

	Transparent_color_32_bit: INTEGER = 0x1000000

end