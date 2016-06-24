note
	description: "${description}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_IM_SVG_TO_PNG_CONVERTER

inherit
	EL_IM_API

	EL_MEMORY
		redefine
			dispose
		end

	EL_MODULE_ARGS

create
	make

feature {NONE} -- Initialization

	make
		do
			c_magick_wand_genesis
		end

feature -- Element change

	set_input_path (a_input_path: like input_path)
		do
			input_path := a_input_path
		end

	set_output_path (a_output_path: like output_path)
		do
			output_path := a_output_path
		end

	set_width (a_width: like width)
		do
			width := a_width
		end

	set_background_color_24_bit (a_background_color_24_bit: like background_color_24_bit)
		do
			background_color_24_bit := a_background_color_24_bit
		end

feature -- Basic operations

	execute
		local
			wand: EL_IM_WAND
		do
			create wand.make
			edit_svg_file_backround_color
			wand.set_image (input_path)
			wand.set_image_width (width)
			wand.set_image_format ("PNG")
			wand.write_image (output_path)
			wand.close
		end

feature -- Access

	background_color_24_bit: INTEGER

	width: INTEGER

	input_path: EL_FILE_PATH

	output_path: EL_FILE_PATH

feature {NONE} -- Implementation

	edit_svg_file_backround_color
		local
			file: PLAIN_TEXT_FILE
			last_position, offset, fill_attribute_pos: INTEGER
			done: BOOLEAN
			fill_attribute, fill_color: STRING
		do
			fill_attribute := "fill:#"
			fill_color := background_color_24_bit.to_hex_string
			fill_color.remove_head (2)
			create file.make_open_read_write (input_path)
			from file.read_line until done loop
				last_position := file.position
				file.read_line
				if file.last_string.starts_with ("<rect") then
					fill_attribute_pos := file.last_string.substring_index (fill_attribute, 1)
					if fill_attribute_pos > 0 then
						offset := fill_attribute_pos + fill_attribute.count - 1
						file.go (last_position + offset)
						file.put_string (fill_color)
					end
					done := True

				elseif file.end_of_file then
					done := True
				end
			end
			file.close
		end

feature {NONE} -- Disposal

	dispose
		do
			c_magick_wand_terminus
		end

	Command_name: STRING = "convert"
end
