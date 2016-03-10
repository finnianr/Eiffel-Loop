note
	description: "Summary description for {SMALL_DEVICE_MP3_MEDIA_ITEM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 13:25:10 GMT (Monday 24th June 2013)"
	revision: "2"

class
	SMALL_DEVICE_MP3_MEDIA_ITEM

inherit
	UNIQUELY_IDENTIFIABLE_MEDIA_ITEM
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (a_mp3_path: like mp3_path; a_root_path: like root_path)
			--
		require else
			file_name_is_a_hexadecimal: String.is_hexadecimal (a_mp3_path.without_extension.base)
		do
			Precursor (a_mp3_path, a_root_path)
			unique_id := String.hexadecimal_to_integer (a_mp3_path.without_extension.base)
		end

end
