note
	description: "Pixmap or buffer that is convertable to JPEG image that can be saved to file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-01 12:08:54 GMT (Saturday 1st August 2020)"
	revision: "5"

deferred class
	EL_JPEG_CONVERTABLE

inherit
	EV_ANY
		undefine
			copy, is_equal, is_in_default_state, out
		end

feature -- Basic operations

	save_as_jpeg (file_path: EL_FILE_PATH; quality: NATURAL)
		do
			to_jpeg (quality).save_as (file_path)
		end

feature -- Conversion

	to_jpeg (quality: NATURAL): EL_JPEG_IMAGE
		do
			create Result.make (Current, quality)
		end

end
