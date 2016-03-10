note
	description: "Summary description for {J_COLOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2011-10-11 14:58:17 GMT (Tuesday 11th October 2011)"
	revision: "1"

class
	J_COLOR

inherit
	JAVA_AWT_JPACKAGE

	J_OBJECT
		undefine
			Jclass, Package_name
		end

create
	default_create,
	make, make_from_pointer,
	make_from_java_method_result, make_from_java_attribute,
	make_from_rgb, make_from_24_bit_rgb, make_from_rgb_floats

feature {NONE} -- Initialization

	make_from_24_bit_rgb (rgb_24_bit: INTEGER)
			--
		local
			r, g, b: J_INT
		do
			r := (rgb_24_bit // 0x10000) * 0x101
			g := ((rgb_24_bit // 0x100) \\ 0xFF00) * 0x101
			b := (rgb_24_bit \\ 0xFFFF00) * 0x101
			make_from_rgb (r, g, b)
		end

	make_from_rgb (r, g, b: J_INT)
			--
		do
			make_from_pointer (jagent_make_from_rgb.java_object_id (Current, [r, g, b]))
		end

	make_from_rgb_floats (r, g, b: J_FLOAT)
			--
		do
			make_from_pointer (jagent_make_from_rgb_floats.java_object_id (Current, [r, g, b]))
		end

feature {NONE} -- Implementation

	jagent_make_from_rgb: JAVA_CONSTRUCTOR [J_COLOR]
			--
		once
			create Result.make (agent make_from_rgb)
		end

	jagent_make_from_rgb_floats: JAVA_CONSTRUCTOR [J_COLOR]
			--
		once
			create Result.make (agent make_from_rgb)
		end

feature {NONE} -- Constant

	Jclass: JAVA_CLASS_REFERENCE
			--
		once
			create Result.make (Package_name, "Color")
		end

end
