note
	description: "Multimedia constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_MULTIMEDIA_CONSTANTS

feature -- Constants

	File_extension_wav: ZSTRING
		once
			Result := "wav"
		end

	File_extension_mp3: ZSTRING
		once
			Result := "mp3"
		end

	Video_extensions: ARRAY [ZSTRING]
		once
			Result := << "flv", "mp4", "mov" >>
			Result.compare_objects
		end

end