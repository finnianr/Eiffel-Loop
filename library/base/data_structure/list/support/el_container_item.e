note
	description: "[
		First or else uninitialized [$source CONTAINER] item for testing as valid routine operand
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-12 19:18:45 GMT (Wednesday 12th October 2022)"
	revision: "1"

class
	EL_CONTAINER_ITEM [G]

inherit
	EL_TRAVERSABLE_STRUCTURE [G]
		export
			{NONE} all
		end

	EL_MODULE_EIFFEL

create
	make

feature {NONE} -- Initialization

	make (container: CONTAINER [G])
		do
			if container.is_empty then
				if attached {G} Eiffel.new_instance_of (({G}).type_id) as new then
					item := new
				end

			elseif attached {READABLE_INDEXABLE [G]} container as array then
				item := array [array.lower]

			elseif attached container.linear_representation as list then
				if container = list and then attached {TRAVERSABLE [G]} list as traversable then
					current_traversable := traversable; push_cursor
				end
				list.start
				item := list.item
				if attached current_traversable as traversable then
					pop_cursor
					current_traversable := Void
				end
			end
		end

feature -- Status query

	is_valid_for (routine: ROUTINE [G]): BOOLEAN
		do
			if routine.open_count = 1 and then attached item as l_item  then
				Result := routine.valid_operands ([l_item])
			end
		end

feature -- Access

	item: detachable G

feature {NONE} -- Internal attributes

	current_traversable: detachable TRAVERSABLE [G]

end