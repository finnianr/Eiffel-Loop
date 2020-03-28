note
	description: "Task to query or edit ID3 tag information"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-27 15:43:42 GMT (Friday 27th March 2020)"
	revision: "2"

deferred class
	ID3_TASK

inherit
	RBOX_MANAGEMENT_TASK

	ID3_TAG_INFO_ROUTINES undefine is_equal end

end
