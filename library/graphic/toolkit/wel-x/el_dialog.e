note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
	EL_DIALOG

inherit
	WEL_FRAME_WINDOW
		rename
	 		make_child as make_child_frame
	 	redefine
	 		on_set_focus,
	 		Background_brush, on_wm_close, closeable, Default_style
	 	end

	EL_WINDOW_LAYOUT
	
feature {NONE} -- Initialization

	make_child_dialog (a_parent: WEL_WINDOW; a_name: STRING; a_width, a_height: INTEGER)
			--
		do
			make_child_frame (a_parent, a_name)
			make_window_layout (a_width, a_height)

			create tabbed_controls.make
			create pending_edits.make
			create label_list.make
		end
		
feature {NONE} -- Event handlers

	on_set_focus
			-- Wm_setfocus message
		do
			if not tabbed_controls.is_empty  then
				tabbed_controls.first.set_focus
			end
		end

	on_wm_close
			-- Wm_close message.
			-- If `closeable' is False further processing is halted.
		do
			Precursor
			on_ok
		end

	on_ok
			-- Button Ok has been pressed.
		do
			hide
		end
		
feature {EL_CONTROL} -- Event handlers

	on_field_edit (field: EL_TEXT_EDIT_FIELD)
			--
		do
			if not pending_edits.has (field) then
				pending_edits.extend (field)
			end
			on_pending_edit
		end

	on_pending_edit
			-- A new edit has been added to the pending list
		deferred
		end
	
	on_pending_edits_applied
			-- All pending edits have been applied
		deferred
		end
	
feature -- Basic operation

	add_control (control: EL_CONTROL)
			--
		do
			tabbed_controls.extend (control)
		end
		
	tab_to_control_left (control: EL_CONTROL)
			--
		do
			tabbed_controls.search (control)
			from
				tabbed_controls.back
			until
				tabbed_controls.item.enabled
			loop
				tabbed_controls.back
			end
			tabbed_controls.item.set_focus
		end
		
	tab_to_control_right (control: EL_CONTROL)
			--
		do
			tabbed_controls.search (control)
			from
				tabbed_controls.forth
			until
				tabbed_controls.item.enabled
			loop
				tabbed_controls.forth
			end
			tabbed_controls.item.set_focus
		end
		
	apply_pending_edits
			--
		do
			pending_edits.do_all (agent {EL_TEXT_EDIT_FIELD}.apply_edit)
			pending_edits.wipe_out
			on_pending_edits_applied
		end

	add_label (label: STRING)
			-- Add label to current layout position
		do
			label_list.extend (
				create {WEL_STATIC}.make (
					Current, label,
					layout_pos.x, layout_pos.y, layout_size.width, layout_size.height, -1
				)
			)
		end
		
feature {NONE} -- Implementation

	tabbed_controls: LINKED_CIRCULAR [WEL_CONTROL]

	pending_edits: LINKED_LIST [EL_TEXT_EDIT_FIELD]
			-- Edits pending application

	label_list: LINKED_LIST [WEL_STATIC]

feature -- Status report

	closeable: BOOLEAN
			-- Can the user close the window?
			-- Yes by default.
		do
			Result := False
		end
	
feature {NONE} -- Default constants

	Background_brush: WEL_BRUSH
			-- background color
		do
			create Result.make_by_sys_color (Color_btnface + 1)
		end

	Default_style: INTEGER
			--
		once
			Result := WS_caption | WS_sysmenu
		end
	

end



