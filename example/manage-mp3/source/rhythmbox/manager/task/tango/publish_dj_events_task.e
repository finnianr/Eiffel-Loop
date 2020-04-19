note
	description: "Publish dj events task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-19 9:13:39 GMT (Sunday 19th April 2020)"
	revision: "5"

class
	PUBLISH_DJ_EVENTS_TASK

inherit
	RBOX_MANAGEMENT_TASK

create
	make

feature -- Basic operations

	apply
		local
			events_publisher: DJ_EVENTS_PUBLISHER
		do
			create events_publisher.make (publish, Database.dj_playlists)
			events_publisher.publish
		end

feature {NONE} -- Internal attributes

	publish: DJ_EVENT_PUBLISHER_CONFIG

end
