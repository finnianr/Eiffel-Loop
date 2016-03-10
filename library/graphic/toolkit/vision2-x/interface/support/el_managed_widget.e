note
	description: "[
		Object to manage a containable widget in a searchable container.
		The update routine causes the widget item to be replaced with a new widget created by the factory function
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_MANAGED_WIDGET [W -> EV_WIDGET create default_create end]

inherit
	ANY
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

	make_with_container (a_container: like container; a_factory_function: like factory_function)
		do
			container := a_container; factory_function := a_factory_function
			factory_function.apply
			item := factory_function.last_result
			container.extend (item)
		end

feature -- Element change

	update
			-- replace item with a new item
		local
			is_widget_expanded, widget_found: BOOLEAN
			new_widget: EV_WIDGET
		do
			if attached {EV_WIDGET_LIST} container as widget_list then
				widget_list.start
				widget_list.search (item)
				widget_found := not widget_list.exhausted
			else
				widget_found := True
			end
			if widget_found then
				factory_function.apply
				if attached {EV_BOX} container as box then
					is_widget_expanded := box.is_item_expanded (item)
					new_widget := factory_function.last_result
					box.replace (new_widget)
					if is_widget_expanded then
						box.enable_item_expand (new_widget)
					else
						box.disable_item_expand (new_widget)
					end
				else
					container.replace (factory_function.last_result)
				end
				item := factory_function.last_result
			end
		end

feature -- Access

	item: W

	container: EV_CONTAINER

feature -- Element change

	set_factory_function (a_factory_function: like factory_function)
		do
			factory_function := a_factory_function
		end

feature {NONE} -- Implementation

	create_default_item: W
		do
			create Result
		end

	factory_function: FUNCTION [ANY, TUPLE, W]

end
