note
	description: "[
		Bioinformatic data demonstrating building from recursive XML
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-19 12:50:20 GMT (Tuesday 19th November 2024)"
	revision: "7"

class
	BIOINFORMATIC_COMMANDS

inherit
	EL_BUILDABLE_FROM_XML
		rename
			make_default as make
		redefine
			make, building_action_table
		end

	EL_MODULE_LOG

create
	make_from_file, make_from_string, make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			create commands.make
		end

feature -- Access

	commands: LINKED_LIST [BIOINFO_COMMAND]

feature -- Basic operations

	display
			--
		do
			log.enter ("display")
			from commands.start until commands.after loop
				commands.item.display
				commands.forth
			end
			log.exit
		end

feature {NONE} -- Build from XML

	extend_commands
			--
		do
			commands.extend (create {BIOINFO_COMMAND}.make)
			set_next_context (commands.last)
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to root element: bix
		do
			create Result.make_assignments (<<
				["package/command", agent extend_commands]
			>>)
		end

	Root_node_name: STRING = "bix"

note
	notes: "[
		**Example Document**

			<bix>
				<package>
					<command>
						<parlist>
							<par>
								<value type="boolean">true</value>
							</par>
								<value type="container">
									<parlist>
										<par>
											<value type="boolean">true</value>
										</par>
										<par>
											<value type="integer">12</value>
										</par>
										</par>
											<value type="container">
												<parlist>
													<par>
														<value type="boolean">true</value>
													</par>
													<par>
														<value type="integer">12</value>
													</par>
												</parlist>
											</value>
										<par>
									</parlist>
								</value>
							<par>
							</par>
						</parlist>
					</command>
				</package>
			</bix>
	]"

end