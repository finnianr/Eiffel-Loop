note
	description: "Summary description for {EL_MULTIMEDIA_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-10-12 11:40:26 GMT (Saturday 12th October 2013)"
	revision: "3"

class
	EL_MULTIMEDIA_CONSTANTS

feature -- Constants

	File_extension_wav: ASTRING
		once
			Result := "wav"
		end

	File_extension_mp3: ASTRING
		once
			Result := "mp3"
		end

end
