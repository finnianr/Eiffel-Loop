note
	description: "Publish DJ events task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-22 15:03:23 GMT (Tuesday 22nd August 2023)"
	revision: "7"

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
			lio.put_labeled_string ("ftp salt", publish.ftp_site.credential.salt_base_64)
			lio.put_new_line
			lio.put_labeled_string ("ftp digest", publish.ftp_site.credential.digest_base_64)
			lio.put_new_line
			create events_publisher.make (publish, Database.dj_playlists)
			events_publisher.publish
		end

feature {EL_EQA_TEST_SET} -- Internal attributes

	publish: DJ_EVENT_PUBLISHER_CONFIG

end