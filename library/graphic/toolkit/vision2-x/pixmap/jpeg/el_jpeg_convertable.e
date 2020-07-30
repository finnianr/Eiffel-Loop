note
	description: "Pixmap or buffer that is convertable to JPEG image that can be saved to file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-14 14:42:34 GMT (Tuesday 14th July 2020)"
	revision: "4"

deferred class
	EL_JPEG_CONVERTABLE

inherit
	ANY
		undefine
			copy, default_create, is_equal, out
		end

feature -- Basic operations

	save_as_jpeg (file_path: EL_FILE_PATH; quality: NATURAL)
		do
			to_jpeg (quality).save_as (file_path)
		end

feature -- Conversion

	to_jpeg (quality: NATURAL): EL_JPEG_IMAGE_I
		do
			create {EL_JPEG_IMAGE_IMP} Result.make (implementation, quality)
		end

feature {NONE} -- Implementation

	implementation: EV_ANY_I
		deferred
		ensure
			valid_type: attached {EV_PIXMAP_I} Result or attached {EL_DRAWABLE_PIXEL_BUFFER_I} Result
		end

end
