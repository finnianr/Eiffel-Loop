note
	description: "Color constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-30 14:12:40 GMT (Thursday 30th May 2019)"
	revision: "3"

class
	MODEL_CONSTANTS

inherit
	EL_MODULE_COLOR

	EL_MODULE_IMAGE

feature {NONE} -- Constants

	Doll_head_pixels: EL_DRAWABLE_PIXEL_BUFFER
		once
			create Result.make_with_path (Image.image_path ("doll-head.png"))
		end

	Doll_base_pixels: EL_DRAWABLE_PIXEL_BUFFER
		once
			create Result.make_with_path (Image.image_path ("doll-base.png"))
		end

	Color_placeholder: EV_COLOR
		once
			Result := Color.new_html ("#E0E0E0")
		end

	Color_skirt: EV_COLOR
		once
			Result := Color.new_html ("#0099A4")
		end

end
