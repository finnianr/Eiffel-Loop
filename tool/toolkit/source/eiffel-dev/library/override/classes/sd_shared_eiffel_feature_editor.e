note
	description: "Summary description for {SD_SHARED_EIFFEL_FEATURE_EDITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SD_SHARED_EIFFEL_FEATURE_EDITOR

inherit
	EIFFEL_OVERRIDE_FEATURE_EDITOR
		redefine
			write_edited_lines
		end

create
	make

feature -- Basic operations

	write_edited_lines (output_path: EL_FILE_PATH)
		local
			class_feature: CLASS_FEATURE
			type_definition_group: CLASS_FEATURE_GROUP
		do
--			Widget_factory_cell: CELL [SD_WIDGET_FACTORY]
			start; search (Group_implementation)
			if group_found then
				search (Group_implementation)
				if group_found then
					create class_feature.make_with_lines (Source_widget_factory_cell)
					class_feature.lines.indent
					found_group.features.extend (class_feature)
				end
			end

--			Type_widget_factory: SD_WIDGET_FACTORY
			type_definition_group := new_feature_group ("NONE", "Type definitions")
			type_definition_group.features.extend (create {CLASS_FEATURE}.make_with_lines (Source_type_widget_factory))
			type_definition_group.features.last.lines.indent

			feature_groups.extend (type_definition_group)

			Precursor (output_path)
		end

feature {NONE} -- Implementation

	new_feature_edit_actions: like feature_edit_actions
		do
			create Result.make (<<
				["widget_factory", agent replace_widget_factory]
			>>)
		end

	replace_widget_factory (a_feature: CLASS_FEATURE)
		do
			a_feature.set_lines (Source_widget_factory)
		end

feature {NONE} -- Constants

	Source_widget_factory_cell: EIFFEL_SOURCE_LINES
		once
			create Result.make_with_lines ("[
				Widget_factory_cell: CELL [SD_WIDGET_FACTORY]
					once ("PROCESS")
						create Result.put (Void)
					end
				
			]")
		end

	Source_type_widget_factory: EIFFEL_SOURCE_LINES
		once
			create Result.make_with_lines ("[
				Type_widget_factory: SD_WIDGET_FACTORY
					once
					end
				
			]")
		end

	Source_widget_factory: EIFFEL_SOURCE_LINES
		once
			create Result.make_with_lines ("[
				widget_factory: like Type_widget_factory
						-- SD_WIDGET_FACTORY instance.
					do
						if attached {like Type_widget_factory} widget_factory_cell.item as l_result then
							Result := l_result
						else
							create Result.make
							widget_factory_cell.put (Result)
						end
					end
				
			]")
		end

	Group_implementation: EL_ASTRING
		once
			Result := "Implementation"
		end

end
