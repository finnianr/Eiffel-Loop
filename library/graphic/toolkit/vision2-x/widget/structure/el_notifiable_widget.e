note
	description: "Widget field that can be notified to replace itself by implementing ${EL_EVENT_LISTENER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-10 13:27:47 GMT (Sunday 10th November 2024)"
	revision: "5"

deferred class
	EL_NOTIFIABLE_WIDGET [G -> EV_WIDGET]

inherit
	EL_WIDGET_REPLACEMENT [G]

	EL_EVENT_LISTENER
		rename
			notify as replace_item
		end

end