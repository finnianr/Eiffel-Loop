note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-18 12:56:56 GMT (Sunday 18th October 2020)"
	revision: "20"

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
		RBOX_AUTOTEST_APP
	]

create
	make

end