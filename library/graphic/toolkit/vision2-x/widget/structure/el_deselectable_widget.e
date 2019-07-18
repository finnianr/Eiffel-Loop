note
	description: "Deselectable widget"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-15 12:14:17 GMT (Monday 15th July 2019)"
	revision: "2"

deferred class
	EL_DESELECTABLE_WIDGET

inherit
	EV_DESELECTABLE

	EL_MODULE_ZSTRING

feature {NONE} -- Initialization

	make_with_text (a_text: READABLE_STRING_GENERAL; selected: BOOLEAN; a_set_selected: like set_selected)
		do
			make (selected, a_set_selected)
			set_text (Zstring.to_unicode_general (a_text))
		end

	make (selected: BOOLEAN; a_set_selected: like set_selected)
		do
			default_create
			if selected then
				enable_select
			end
			set_selected := a_set_selected
			select_actions.extend (agent on_select)
		end

feature -- Element change

	set_initial (selected: BOOLEAN)
		do
			select_actions.block
			if selected then
				enable_select
			else
				disable_select
			end
			select_actions.resume
		end

feature {NONE} -- Event handling

	on_select
		do
			set_selected (is_selected)
		end

feature {NONE} -- Internal attributes

	set_selected: PROCEDURE [BOOLEAN]

feature {NONE} -- Implementation

	select_actions: EV_NOTIFY_ACTION_SEQUENCE
		deferred
		end

	set_text (a_text: separate READABLE_STRING_GENERAL)
		deferred
		end

end
