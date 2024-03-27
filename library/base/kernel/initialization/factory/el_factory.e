note
	description: "Abstract factory for objects of type **G**"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-26 13:08:42 GMT (Tuesday 26th March 2024)"
	revision: "3"

deferred class
	EL_FACTORY [G]

feature -- Factory

	new_item: detachable G
	  deferred
	  end
note
	descendants: "[
			EL_FACTORY* [G]
				${EL_REFLECTED_COLLECTION_FACTORY} [G, R -> ${EL_REFLECTED_COLLECTION} [G] create make, default_create end]
				${EL_MAKEABLE_FACTORY} [G -> ${EL_MAKEABLE} create make end]
				${EL_STRING_FACTORY} [S -> ${READABLE_STRING_GENERAL} create make_empty end]
				${EL_MAKEABLE_FROM_STRING_FACTORY} [G -> ${EL_MAKEABLE_FROM_STRING} [STRING_GENERAL] create make_default, make_from_general end]
				${EL_TIME_FACTORY} [G -> ${TIME} create make_by_seconds end]
				${EL_ARRAYED_LIST_FACTORY} [G -> ${ARRAYED_LIST} [ANY] create make end]
				${EL_DATE_FACTORY} [G -> ${DATE} create make_by_days end]
				${EL_DATE_TIME_FACTORY} [G -> ${DATE_TIME} create make_from_epoch end]
				${EL_DEFAULT_CREATE_FACTORY} [G -> ${ANY} create default_create end]
				${EL_MAKEABLE_READER_WRITER_FACTORY} [G -> ${EL_MAKEABLE}, S -> ${EL_MAKEABLE_READER_WRITER} [G] create default_create end]
				${EL_REFLECTIVELY_SETTABLE_FACTORY} [S -> ${EL_REFLECTIVELY_SETTABLE} create make_default end]
				${EL_AGENT_FACILITATED_FACTORY} [G]
				${EL_REFLECTED_FIELD_FACTORY} [G -> ${EL_REFLECTED_FIELD} create make end]
				${EL_MAKEABLE_TO_SIZE_FACTORY} [G -> ${EL_MAKEABLE_TO_SIZE} create make end]
	]"
end