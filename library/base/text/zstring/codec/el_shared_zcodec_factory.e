note
	description: "Shared access to frozen class [$source EL_ZCODEC_FACTORY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-14 12:08:46 GMT (Thursday 14th May 2020)"
	revision: "1"

deferred class
	EL_SHARED_ZCODEC_FACTORY

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Codec_factory: EL_ZCODEC_FACTORY
		once
			create Result
		end
end
