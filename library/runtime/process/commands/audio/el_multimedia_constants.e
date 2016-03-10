note
	description: "Summary description for {EL_MULTIMEDIA_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_MULTIMEDIA_CONSTANTS

feature -- Constants

	File_extension_wav: EL_ASTRING
		once
			Result := "wav"
		end

	File_extension_mp3: EL_ASTRING
		once
			Result := "mp3"
		end

end
