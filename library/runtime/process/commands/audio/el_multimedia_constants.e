note
	description: "Summary description for {EL_MULTIMEDIA_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:24:12 GMT (Wednesday 16th December 2015)"
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

end
