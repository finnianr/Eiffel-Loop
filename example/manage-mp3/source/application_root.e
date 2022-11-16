note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "22"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
		ID3_EDITOR_APP,
		MP3_AUDIO_SIGNATURE_READER_APP,
		RHYTHMBOX_MUSIC_MANAGER_APP,
		TANGO_MP3_FILE_COLLATOR_APP,
		EL_DEBIAN_PACKAGER_APP,

	--	Tools
		GENERATE_RBOX_DATABASE_FIELD_ENUM_APP,

	--	Testing
		AUTOTEST_APP
	]

create
	make

end