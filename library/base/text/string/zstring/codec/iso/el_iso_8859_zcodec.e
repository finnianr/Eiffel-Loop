note
	description: "Summary description for {EL_ISO_8859_CODEC_2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	EL_ISO_8859_ZCODEC

inherit
	EL_ZCODEC
		export
			{EL_FACTORY_CLIENT} make
		end

feature -- Access

	Type: STRING = "ISO-8859"
end