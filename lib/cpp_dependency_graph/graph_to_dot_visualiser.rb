# frozen_string_literal: true

require 'graphviz'

# Outputs a `dot` langugage representation of a dependency graph
class GraphToDotVisualiser
  def generate(deps, file)
    @g = Graphviz::Graph.new('dependency_graph')
    nodes = create_nodes(deps)
    connect_nodes(deps, nodes)
    File.write(file, @g.to_dot)
  end

  private

  def create_nodes(deps)
    node_names = deps.flat_map do |_, links|
      links.map { |link| [link.source, link.target] }.flatten
    end.uniq
    nodes = node_names.map { |name| [name, create_node(name)] }.to_h
    nodes
  end

  def create_node(name)
    node = @g.add_node(name)
    node.attributes[:shape] = 'box3d'
    node
  end

  def connect_nodes(deps, nodes)
    deps.each do |source, links|
      links.each do |link|
        connection = nodes[source].connect(nodes[link.target])
        connection.attributes[:color] = 'red' if link.cyclic?
      end
    end
  end
end
