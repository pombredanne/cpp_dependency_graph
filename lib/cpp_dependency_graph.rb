# frozen_string_literal: true

require_relative 'cpp_dependency_graph/project'
require_relative 'cpp_dependency_graph/dependency_graph'
require_relative 'cpp_dependency_graph/graph_to_dot_converter'

# Generate dependency graph of a project as a dot file
module CppDependencyGraph
  def generate(args)
    project = Project.new(args.project_dir)
    graph = DependencyGraph.new(project)
    deps = args[:component].nil? ? graph.all_component_dependencies : graph.component_dependencies(args.component)
    GraphToDotConverter.generate(deps, args.output_file)
  end
end
