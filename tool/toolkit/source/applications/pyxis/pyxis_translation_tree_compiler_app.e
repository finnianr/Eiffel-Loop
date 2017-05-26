note
	description: "[
		Compiles tree of Pyxis translation files into multiple locale files.
		Does nothing if source files are all older than locale files.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-24 13:05:41 GMT (Wednesday 24th May 2017)"
	revision: "1"

class
	PYXIS_TRANSLATION_TREE_COMPILER_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATION [PYXIS_TRANSLATION_TREE_COMPILER]
		redefine
			Option_name, normal_initialize
		end

create
	make

feature -- Testing

	test_run
			--
		do
			Test.do_file_tree_test ("pyxis/localization", agent test_compile, 4017141382)
		end

	test_compile (source_tree_path: EL_DIR_PATH)
			--
		local
			table: EL_LOCALE_TABLE; same_items: BOOLEAN
			restored_list: EL_TRANSLATION_ITEMS_LIST
			translations_table: like command.translations_table
			restored_table, filled_table: EL_TRANSLATION_TABLE
		do
			log.put_new_line
			across 1 |..| 2 as n loop
				log.put_integer_field ("Run", n.item)
				log.put_new_line
				create command.make (source_tree_path, source_tree_path.parent)
				normal_run
				if n.item = 1 then
					translations_table := command.translations_table
				end
				log.put_new_line
			end
			log.put_line ("Checking restore")
			create table.make (source_tree_path.parent)
			across table as language loop
				log.put_string_field ("language", language.key)
				create restored_list.make_from_file (language.item)
				restored_list.retrieve

				restored_table := restored_list.to_table (language.key)
				filled_table := translations_table.item (language.key).to_table (language.key)
				same_items := restored_table.count = filled_table.count and then
					across restored_table as translation all
						translation.item ~ filled_table [translation.key]
					end
				if same_items then
					log.put_labeled_string (" same_items", "OK")
				else
					log.put_labeled_string (" ERROR", "restored items do not match")
				end
				log.put_new_line
			end
		end

feature {NONE} -- Implementation

	normal_initialize
		do
			Console.show ({PYXIS_TRANSLATION_TREE_COMPILER})
			Precursor
		end

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [source_tree_dir, output_dir: EL_DIR_PATH]
		do
			create Result
			Result.source_tree_dir := ""
			Result.output_dir := ""
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_existing_path_argument ("source", "Source tree directory"),
				required_argument ("output", "Output directory path")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "compile_translations"

	Description: STRING = "Compile tree of Pyxis translation files into multiple locale files"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{PYXIS_TRANSLATION_TREE_COMPILER_APP}, All_routines]
			>>
		end

end
