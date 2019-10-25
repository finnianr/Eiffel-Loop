note
	description: "Tl mpeg file cpp api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-25 18:19:06 GMT (Friday   25th   October   2019)"
	revision: "1"

class
	TL_MPEG_FILE_CPP_API

feature {NONE} -- Constructor

	frozen cpp_new (file: POINTER): POINTER
		--	File	(FileName file, bool readProperties = true,
		--			Properties::ReadStyle propertiesStyle = Properties::Average);
		external
			"C++ inline use <mpeg/mpegfile.h>"
		alias
			"new TagLib::MPEG::File ((TagLib::FileName)$file)"
		end

end
