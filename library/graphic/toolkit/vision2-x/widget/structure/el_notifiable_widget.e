note
	description: "Widget field that can be notified to replace itself by implementing ${EL_EVENT_LISTENER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "4"

deferred class
	EL_NOTIFIABLE_WIDGET

inherit
	EL_REPLACEABLE_WIDGET_ITEM

	EL_EVENT_LISTENER
		rename
			notify as replace_item
		end

end