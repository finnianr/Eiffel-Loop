note
	description: "Youtube stream download list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-25 13:08:36 GMT (Tuesday 25th April 2023)"
	revision: "9"

class
	EL_YOUTUBE_STREAM_DOWNLOAD_LIST

inherit
	EL_ARRAYED_LIST [EL_YOUTUBE_STREAM_DOWNLOAD]

	EL_MODULE_LIO

	EL_YOUTUBE_CONSTANTS

create
	make

feature -- Access

	audio: detachable EL_YOUTUBE_STREAM_DOWNLOAD
		-- selected video stream download
		do
			if count > 0 then
				Result := first
			end
		ensure
			valid_type: attached Result as download implies download.stream.type = Audio_type
		end

	video: detachable EL_YOUTUBE_STREAM_DOWNLOAD
		-- selected video stream download
		do
			if count = 2 then
				Result := last
			end
		ensure
			valid_type: attached Result as download implies download.stream.type = Video_type
		end

feature -- Status query

	exist: BOOLEAN
		do
			Result := across Current as list all list.item.exists end
		end

feature -- Basic operations

	download_all
		do
			across Current as list loop
				list.item.execute
			end
		end
end