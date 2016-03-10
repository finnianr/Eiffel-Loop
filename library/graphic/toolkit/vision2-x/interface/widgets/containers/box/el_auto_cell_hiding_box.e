note
	description: "[
		A box that will hide selected widget members if the mouse pointer is not over the box,
		and show them if the pointer enters the box.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 16:49:26 GMT (Tuesday 18th June 2013)"
	revision: "2"

deferred class
	EL_AUTO_CELL_HIDING_BOX

inherit
	EL_BOX
		rename
			remove as internal_remove,
			merge_right as internal_merge_right,
			Screen as Mod_screen
		redefine
			make
		end

	EL_MODULE_GUI
		undefine
			is_equal, default_create, copy
		end

	EL_MODULE_LOG
		undefine
			is_equal, default_create, copy
		end

feature {NONE} -- Initialization

	make (border_cms, padding_cms: REAL)
		do
			Precursor (border_cms, padding_cms)
			create hidden_components.make (3)
			create always_hidden_components.make (3)
			create internal_rectangle
			screen := GUI.screen
			resize_actions.extend (agent on_resize)
		end

feature -- Element change

	remove
		do
			if auto_hide_enabled then
				hidden_components.start; hidden_components.prune (item)
				remove_widget_actions (item)
			end
			internal_remove
		end

	merge_right (other: like Current)
			-- Works fine on GTK but on Windows there are problems with the expansion status,
			-- unexpanded items behave as expanded, even when explicitly set again.
		do
			if auto_hide_enabled then
				other.do_all (agent auto_hide_widget)
			end
			internal_merge_right (other)
		end

feature -- Status change

	enable_always_hidden (a_widget: EV_WIDGET)
		do
			hidden_components.start; hidden_components.prune (a_widget)
			remove_widget_actions (a_widget)
			always_hidden_components.extend (a_widget)
			a_widget.hide
		end

	enable_widget_auto_hide (a_widget: EV_WIDGET)
		do
			always_hidden_components.start; always_hidden_components.prune (a_widget)
			auto_hide_widget (a_widget)
		end

	enable_shown (a_widget: EV_WIDGET)
		do
			always_hidden_components.prune (a_widget)
			hidden_components.prune (a_widget)
		end

	disable_auto_hide
		do
			hidden_components.wipe_out
			across Current as this loop
				remove_widget_actions (this.item)
				if not always_hidden_components.has (this.item) then
					this.item.show
				end
			end
			auto_hide_enabled := false
		end

	enable_auto_hide
		do
			across Current as this loop
				if not always_hidden_components.has (this.item) then
					auto_hide_widget (this.item)
				end
			end
			auto_hide_enabled := True
		end

feature -- Status query

	auto_hide_enabled: BOOLEAN

feature {NONE} -- Events

	on_enter (a_widget: EV_WIDGET)
		do
--			log.enter ("on_enter")
			if auto_hide_enabled then
				across hidden_components as hidden loop hidden.item.show end
				auto_hide_enabled := False
			end
--			log.exit
		end

	on_leave (a_widget: EV_WIDGET)
		do
--			log.enter ("on_leave")
			if not across Current as this some widget_has_pointer (this.item) end then
				across hidden_components as hidden loop hidden.item.hide end
				auto_hide_enabled := True
--				log.put_line ("hidden now")
			end
--			log.exit
		end

	on_resize (a_x, a_y, a_width, a_height: INTEGER)
			--
		do
--			log.enter_with_args ("on_resize", << a_x, a_y, a_width, a_height >>)
			if {PLATFORM}.is_windows then
				GUI.do_once_on_idle (agent check_pointer_position)
			end
--			log.exit
		end

feature {NONE} -- Windows workaround

	-- Work around for two bugs in Windows implementation
	-- 1. If the pointer is positioned over the newly created box,
	--    on_enter does not get called unless the pointer moves See #18608

	-- 2. Coordinates of box is misreported in routine on_resize See #18607
	--

	check_pointer_position
			-- check if pointer over this box and if so, nudge the pointer position to
			-- trigger on_enter
		do
--			log.enter ("check_pointer")
			if auto_hide_enabled and then widget_has_pointer (Current) then
				GUI.do_once_on_idle (agent nudge_pointer_position)
			end
--			log.exit
		end

	nudge_pointer_position
		local
			l_position: EV_COORDINATE
		do
			l_position := screen.pointer_position
			screen.set_pointer_position (l_position.x, l_position.y + Wobble_offset)
			Wobble_offset.set_item (-Wobble_offset)
		end

	Wobble_offset: INTEGER_REF
		once
			create Result
			Result.set_item (1)
		end

feature {NONE} -- Implementation

	auto_hide_widget (a_widget: EV_WIDGET)
		do
			a_widget.pointer_enter_actions.extend (agent on_enter (a_widget))
			a_widget.pointer_leave_actions.extend (agent on_leave (a_widget))
			if not a_widget.is_show_requested then
				hidden_components.extend (a_widget)
			end
		end

	remove_widget_actions (a_widget: EV_WIDGET)
		do
			remove_action (a_widget.pointer_enter_actions, create {EL_PROCEDURE}.make (agent on_enter))
			a_widget.pointer_enter_actions.resume

			remove_action (a_widget.pointer_leave_actions, create {EL_PROCEDURE}.make (agent on_leave))
			a_widget.pointer_leave_actions.resume
		end

	remove_action (actions: EV_NOTIFY_ACTION_SEQUENCE; action_to_remove: EL_PROCEDURE)
		do
			from actions.start until actions.after loop
				if action_to_remove.same_procedure (actions.item) then
					actions.remove
				else
					actions.forth
				end
			end
		end

	widget_has_pointer (a_widget: EV_WIDGET): BOOLEAN
		do
			internal_rectangle.move_and_resize (a_widget.screen_x, a_widget.screen_y, a_widget.width, a_widget.height)
			Result := internal_rectangle.has (screen.pointer_position)
		end

	screen: EV_SCREEN

	internal_rectangle: EV_RECTANGLE

	hidden_components: EL_ARRAYED_LIST [EV_WIDGET]
		-- widgets that are hidden only while cursor is not over the box

	always_hidden_components: ARRAYED_LIST [EV_WIDGET]
		-- widgets that are always hidden even if the cursor is over the box

end
