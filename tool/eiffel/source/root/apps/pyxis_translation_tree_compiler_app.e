note
	description: "[
		Sub app to compile tree of Pyxis translation files into multiple locale files named `locale.x'
		where `x' is a 2 letter country code. Does nothing if source files are all older
		than locale files. See class [$source EL_LOCALE_I]
		
		Syntax:
		
			el_toolkit -compile_translations -source <source tree dir> -output <output dir>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-25 11:15:11 GMT (Monday 25th November 2019)"
	revision: "10"

class
	PYXIS_TRANSLATION_TREE_COMPILER_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [PYXIS_TRANSLATION_TREE_COMPILER]
		redefine
			Option_name, normal_initialize
		end

create
	make

feature -- Testing

	test_run
			--
		do
			Test.do_file_tree_test ("localization", agent test_compile, 3207102311)
		end

	test_compile (source_tree_path: EL_DIR_PATH)
			--
		local
			table: EL_LOCALE_TABLE; same_items: BOOLEAN
			restored_list: EL_TRANSLATION_ITEMS_LIST
			translations_table: like command.translations_table
			restored_table, filled_table: EL_TRANSLATION_TABLE
			locale_dir: EL_DIR_PATH
		do
			log.put_new_line
			locale_dir := source_tree_path.parent.joined_dir_tuple (["locales"])
			across 1 |..| 2 as n loop
				log.put_integer_field ("Run", n.item)
				log.put_new_line
				create command.make (source_tree_path, locale_dir)
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

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("source", "Source tree directory", << directory_must_exist >>),
				required_argument ("output", "Output directory path")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "")
		end

	normal_initialize
		do
			Console.show ({PYXIS_TRANSLATION_TREE_COMPILER})
			Precursor
		end

feature {NONE} -- Constants

	Option_name: STRING = "compile_translations"

	Description: STRING = "Compile tree of Pyxis translation files into multiple locale files"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{PYXIS_TRANSLATION_TREE_COMPILER_APP}, All_routines]
			>>
		end

end