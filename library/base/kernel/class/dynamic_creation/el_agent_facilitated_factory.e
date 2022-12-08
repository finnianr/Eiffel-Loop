note
	description: "[
		[$source EL_FACTORY] that looks up a shared factory [$source FUNCTION] by type_id
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-08 7:06:11 GMT (Thursday 8th December 2022)"
	revision: "1"

class
	EL_AGENT_FACILITATED_FACTORY [G]

inherit
	EL_FACTORY [G]

	EL_SHARED_NEW_INSTANCE_TABLE

create
	make

feature {NONE} -- Initialization

	make (type_id: INTEGER)
		do
			if New_instance_table.has_key (type_id)
				and then attached {FUNCTION [G]} New_instance_table.found_item as f
			then
				factory := f
			end
		end

feature -- Status query

	is_useable: BOOLEAN
		do
			Result := attached factory
		end

feature -- Factory

	new_item: G
		require else
			useable: is_useable
		do
			if attached factory as f then
				f.apply
				Result := f.last_result
			end
		end

feature -- Internal attributes

	factory: detachable FUNCTION [G]
end