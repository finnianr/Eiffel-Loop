note
	description: "[
		[https://www.paintshoppro.com/en/pages/jpeg-file/ JPEG] stands for "Joint Photographic Experts Group".
		It's a standard image format for containing lossy and compressed image data.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-28 15:17:45 GMT (Sunday 28th June 2020)"
	revision: "1"

class
	EL_JPEG_FORMAT

inherit
	EV_GRAPHICAL_FORMAT

feature {EV_PIXMAP_I} -- Access

	file_extension: STRING_32
			-- Three character file extension associated with format.
		once
			Result := {STRING_32} "jpg"
		end

	save (raw_image_data: EV_RAW_IMAGE_DATA; a_filepath: PATH)
			-- Save `raw_image_data' to file `a_filepath' in PNG format.
		do
			-- Implemented in pixmap implementation
		end

end
