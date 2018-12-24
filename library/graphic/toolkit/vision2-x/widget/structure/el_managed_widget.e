note
	description: "[
		Object to manage a widget in a container. The `update' routine causes the container
		widget to be replaced with a new widget created by the function `new_item'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 9:24:44 GMT (Friday 21st December 2018)"
	revision: "4"

class
	EL_MANAGED_WIDGET [W -> EV_WIDGET create default_create end]

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
			make_with_container (create {EV_HORIZONTAL_BOX}, agent create_default_item)
		end

feature -- Initialization

	make_with_container (a_container: like container; a_new_item: like new_item)
		do
			container := a_container; new_item := a_new_item
			update
		end

feature -- Element change

	update
			-- replace item with a new item
		do
			new_item.apply
			if widget_found then
				replace (new_item.last_result)
			else
				extend (new_item.last_result)
			end
			item := new_item.last_result
		end

	widget_found: BOOLEAN
		do
			if attached {EV_WIDGET_LIST} container as widget_list then
				widget_list.start
				widget_list.search (item)
				Result := not widget_list.exhausted
			else
				Result := container.has (item)
			end
		end

feature -- Access

	container: EV_CONTAINER

	item: W

feature -- Element change

	set_new_item (a_new_item: like new_item)
		do
			new_item := a_new_item
		end

feature {NONE} -- Implementation

	create_default_item: W
		do
			create Result
		end

	extend (a_item: like item)
		do
			container.extend (a_item)
			if attached {EV_WIDGET_LIST} container as list then
				list.finish
			end
			set_box_expansion (attached {EL_EXPANDABLE} a_item)
		end

	replace (a_item: like item)
		local
			is_expanded: BOOLEAN
		do
			if attached {EV_BOX} container as box then
				is_expanded := box.is_item_expanded (item)
			end
			container.replace (a_item)
			set_box_expansion (is_expanded)
		end

	set_box_expansion (is_expanded: BOOLEAN)
		do
			if attached {EV_BOX} container as box then
				if is_expanded then
					box.enable_item_expand (box.item)
				else
					box.disable_item_expand (box.item)
				end
			end
		end

feature {NONE} -- Internal attributes

	new_item: FUNCTION [W]

end
