require_relative 'lib/classes'

array = 15.times.map { |_i| i = rand(0..100) }
tree = Tree.new(array)
puts tree.balanced? ? "Tree is balanced" : "Tree is unbalanced"

puts 'Level order traversal: '
p tree.level_order

puts 'Preorder traversal: '
p tree.preorder

puts 'Inorder traversal: '
p tree.inorder

puts 'Postorder traversal: '
p tree.postorder

10.times { tree.insert(rand(100..200)) }

puts tree.balanced? ? "Tree is balanced" : "Tree is unbalanced"

tree.rebalance

puts 'Level order traversal: '
p tree.level_order

puts 'Preorder traversal: '
p tree.preorder

puts 'Inorder traversal: '
p tree.inorder

puts 'Postorder traversal: '
p tree.postorder

tree.pretty_print
puts tree.balanced? ? "Tree is balanced" : "Tree is unbalanced"
