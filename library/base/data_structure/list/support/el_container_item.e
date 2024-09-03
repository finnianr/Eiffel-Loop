note
	description: "[
		First or else uninitialized ${CONTAINER} item for testing as valid routine operand
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-03 9:37:03 GMT (Tuesday 3rd September 2024)"
	revision: "5"

class
	EL_CONTAINER_ITEM [G]

inherit
	EL_CONTAINER_STRUCTURE [G]
		export
			{NONE} all
		end

	EL_MODULE_EIFFEL

create
	make

feature {NONE} -- Initialization

	make (container: CONTAINER [G])
		local
			break: BOOLEAN
		do
			if container.is_empty then
				if attached {G} Eiffel.new_object ({G}) as new then
					item := new
				end

			elseif attached {READABLE_INDEXABLE [G]} container as array then
				item := array [array.lower]

			elseif attached {ITERABLE [G]} container as iterable_container then
				across iterable_container as list until break loop
					item := list.item
					break := True
				end

			elseif attached container.linear_representation as list then
				if container = list and then attached {TRAVERSABLE [G]} list as traversable then
					current_container := traversable; push_cursor
				end
				list.start
				item := list.item
				if attached current_container as traversable then
					pop_cursor
					current_container := Void
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

	current_container: detachable TRAVERSABLE [G]

end