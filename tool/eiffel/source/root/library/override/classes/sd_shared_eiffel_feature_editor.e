note
	description: "Summary description for {SD_SHARED_EIFFEL_FEATURE_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-04 12:16:25 GMT (Friday 4th March 2016)"
	revision: "1"

class
	SD_SHARED_EIFFEL_FEATURE_EDITOR

inherit
	OVERRIDE_FEATURE_EDITOR
		redefine
			write_edited_lines
		end

	EL_MODULE_EXCEPTION

create
	make

feature -- Basic operations

	write_edited_lines (output_path: FILE_PATH)
		local
			class_feature: ROUTINE_FEATURE; type_definition_group: FEATURE_GROUP
			implementation_list: LIST [FEATURE_GROUP]
		do
--			Widget_factory_cell: CELL [SD_WIDGET_FACTORY]
			implementation_list := feature_group_list.query_if (agent is_implementation_group)

			if implementation_list.count >= 2 then
				create class_feature.make_with_lines (Source_widget_factory_cell)
				class_feature.lines.indent (1)
				implementation_list.i_th (2).features.extend (class_feature)
			else
				Exception.raise_developer (
					"implementation_list: LIST [FEATURE_GROUP] has only %S groups", [implementation_list.count]
				)
			end

--			Type_widget_factory: SD_WIDGET_FACTORY
			type_definition_group := new_feature_group ("NONE", "Type definitions")
			type_definition_group.features.extend (create {ROUTINE_FEATURE}.make_with_lines (Source_type_widget_factory))
			type_definition_group.features.last.lines.indent (1)

			feature_group_list.extend (type_definition_group)

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

	is_implementation_group (group: FEATURE_GROUP): BOOLEAN
		do
			Result := group.name ~ Implementation
		end

feature {NONE} -- Constants

	Source_widget_factory_cell: SOURCE_LINES
		once
			create Result.make_with_lines ("[
				Widget_factory_cell: CELL [SD_WIDGET_FACTORY]
					once ("PROCESS")
						create Result.put (Void)
					end

			]")
		end

	Source_type_widget_factory: SOURCE_LINES
		once
			create Result.make_with_lines ("[
				Type_widget_factory: SD_WIDGET_FACTORY
					once
					end

			]")
		end

	Source_widget_factory: SOURCE_LINES
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

	Implementation: ZSTRING
		once
			Result := "Implementation"
		end

end

