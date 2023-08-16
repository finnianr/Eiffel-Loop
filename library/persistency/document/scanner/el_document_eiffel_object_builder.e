note
	description: "Eiffel object builder from XML/Pyxix node scanning source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-13 13:13:43 GMT (Sunday 13th August 2023)"
	revision: "17"

class
	EL_DOCUMENT_EIFFEL_OBJECT_BUILDER

inherit
	EL_DOCUMENT_NODE_SCAN_SOURCE
		rename
			seed_object as target,
			set_seed_object as set_target
		redefine
			make_default, set_target, target
		end

create
	make

feature {NONE}  -- Initialisation

	make_default
		do
			create context_stack.make (20)
			target := Default_target
			Precursor
		end

feature {NONE} -- Parsing events

	on_comment
			--
		do
			apply_building_action_for_node (last_node)
		end

	on_content (node: EL_DOCUMENT_NODE_STRING)
			--
		do
			apply_building_action_for_node (node)
		end

	on_end_document
			--
		do
			context_stack.wipe_out
		end

	on_end_tag
			--
		local
			popped_context: EL_EIF_OBJ_XPATH_CONTEXT
		do
			if not context_stack.item.is_xpath_prunable then
				popped_context := context_stack.item
				context_stack.remove
				popped_context.on_context_exit
				context_stack.item.on_context_return (popped_context)
			end
			context_stack.item.remove_xpath_step
		end

	on_processing_instruction
			--
		do
			apply_building_action_for_node (last_node)
		end

	on_start_document
			--
		do
		end

	on_start_tag
			--
		local
			i, j: INTEGER
		do
			if attached context_stack.item as top_item then
				top_item.set_node (last_node)
				top_item.extend_xpath (last_node)
				top_item.do_with_xpath

				if attached top_item.next_context as next_context then
					change_context (next_context)
				end
				if attached attribute_list.area as area and then area.count > 0 then
					from until i = area.count loop
						apply_building_action_for_node (area [i])

						if attached context_stack.item.next_context as next_context then
							change_context (next_context)

							from j := 0 until j = area.count loop
								if i /= j then
									apply_building_action_for_node (area [j])
								end
								j := j + 1
							end
						end
						i := i + 1
					end
				end
			end
		end

feature -- Element change

	set_target (a_target: like target)
			-- set object to build
		local
			root_context: EL_EIF_OBJ_ROOT_BUILDER_CONTEXT
			table: like Root_context_table
		do
			Precursor (a_target)
			target.set_node (last_node)

			table := Root_context_table
			if table.has_key (target.root_node_name) then
				root_context := Root_context_table.found_item
				root_context.set_node (last_node)
			else
				root_context := new_builder_context (target.root_node_name)
			end
			context_stack.extend (root_context)
		end

feature {NONE} -- Implementation

	apply_building_action_for_node (node: EL_DOCUMENT_NODE_STRING)
			--
		do
			if attached context_stack.item as top_item then
				top_item.set_node (node)
				top_item.extend_xpath (node)
				top_item.do_with_xpath
				top_item.remove_xpath_step
			end
		end

	change_context (new_context: EL_EIF_OBJ_XPATH_CONTEXT)
			--
		do
			context_stack.item.reset_next_context
			context_stack.extend (new_context)
		end

	new_builder_context (root_node_name: STRING): EL_EIF_OBJ_ROOT_BUILDER_CONTEXT
			--
		do
			create Result.make (root_node_name, target)
		end

feature {EL_SMART_BUILDABLE_FROM_NODE_SCAN} -- Internal attributes

	context_stack: ARRAYED_STACK [EL_EIF_OBJ_XPATH_CONTEXT]

	target: EL_BUILDABLE_FROM_NODE_SCAN
		-- target object to build from XML node scan

feature {NONE} -- Constants

	Root_context_table: HASH_TABLE [EL_EIF_OBJ_ROOT_BUILDER_CONTEXT, STRING]
			--
		once
			create Result.make (11)
		end

	Default_target: EL_DEFAULT_BUILDABLE_FROM_NODE_SCAN
		once
			create Result.make
		end
end