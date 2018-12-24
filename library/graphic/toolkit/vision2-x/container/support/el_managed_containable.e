note
	description: "[
		Object to manage a containable widget in a container. The `update' routine causes the container
		widget to be replaced with a new widget created by the function `new_item'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 9:25:23 GMT (Friday 21st December 2018)"
	revision: "4"

class
	EL_MANAGED_CONTAINABLE [W -> EV_CONTAINABLE create default_create end]

inherit
	EL_EVENT_LISTENER
		rename
			notify as update
		redefine
			default_create
		end

create
	make_with_container, default_create

feature {NONE} -- Initialization

	default_create
		do
			make_with_container (create {EV_HORIZONTAL_BOX}, agent new_default_item)
		end

	make_with_container (a_container: like container; a_new_item: like new_item)
		do
			container := a_container; new_item := a_new_item
			new_item.apply
			item := new_item.last_result
			container.extend (item)
		end

feature -- Element change

	update
			-- replace item with a new item
		do
			container.start
			container.search (item)
			if not container.exhausted then
				new_item.apply
				container.replace (new_item.last_result)
				item := new_item.last_result
			end
		end

feature -- Access

	item: W

feature {NONE} -- Implementation

	new_default_item: W
		do
			create Result
		end

	container: EV_DYNAMIC_LIST [EV_CONTAINABLE]

	new_item: FUNCTION [W]

end
