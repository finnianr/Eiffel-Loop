note
	description: "Import M4A video stream from Youtube using youtube-dl"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-22 9:11:26 GMT (Friday 22nd May 2020)"
	revision: "1"

class
	IMPORT_YOUTUBE_M4A_TASK

inherit
	IMPORT_VIDEOS_TASK
		rename
			make as make_from_path
		redefine
			apply
		end

create
	make

feature {NONE} -- Initialization

	make (a_url: ZSTRING)
		do
		end

feature -- Basic operations

	apply
		do
		end

end
