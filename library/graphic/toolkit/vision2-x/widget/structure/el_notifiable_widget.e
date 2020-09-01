note
	description: "Widget field that can be notified to replace itself by implementing [$source EL_EVENT_LISTENER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-01 9:19:34 GMT (Tuesday 1st September 2020)"
	revision: "2"

deferred class
	EL_NOTIFIABLE_WIDGET

inherit
	EL_REPLACEABLE_WIDGET_ITEM

	EL_EVENT_LISTENER
		rename
			notify as replace_item
		end

end
