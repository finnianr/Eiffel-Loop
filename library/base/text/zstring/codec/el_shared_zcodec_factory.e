note
	description: "Shared access to frozen class ${EL_ZCODEC_FACTORY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "3"

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