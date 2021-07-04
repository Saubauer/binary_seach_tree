class Node
  include Comparable
  attr_accessor :data, :right, :left

  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def <=>(other)
    value = other.instance_of?(Node) ? other.data : other
    data <=> value
  end
end

class Tree
  def initialize(array)
    arr = array.uniq.sort!
    n = arr.length
    @root = build_tree(arr, 0, n - 1)
    # @root = Node.new(50)
    pretty_print
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def level_order(queue = [@root], &function)
    output = []
    while queue.any?
      node = queue.shift
      block_given? ? function.call(node) : output << node.data
      queue << node.left unless node.left.nil?
      queue << node.right unless node.right.nil?
    end
    output unless block_given?
  end

  def preorder(node = @root, output = [], &function)
    return if node.nil?

    block_given? ? function.call(node) : output << node.data

    preorder(node.left, output, &function)
    preorder(node.right, output, &function)
    output unless block_given?
  end

  def inorder(node = @root, output = [], &function)
    return if node.nil?

    inorder(node.left, output, &function)
    block_given? ? function.call(node) : output << node.data
    inorder(node.right, output, &function)
    output unless block_given?
  end

  def postorder(node = @root, output = [], &function)
    return if node.nil?

    postorder(node.left, output, &function)
    postorder(node.right, output, &function)
    block_given? ? function.call(node) : output << node.data
    output unless block_given?
  end

  def insert(node = @root, value)
    return unless find(value).nil?
    return node = Node.new(value) if node.nil?

    if value < node.data
      node.left = insert(node.left, value)
    else
      node.right = insert(node.right, value)
    end
    node
  end

  def delete(node = @root, value)
    return if node.nil?

    if value < node.data
      node.left = delete(node.left, value)
    elsif value > node.data
      node.right = delete(node.right, value)
    else
      if node.left.nil?
        temp = node.right
        node = nil
        return temp
      elsif node.right.nil?
        temp = node.left
        node = nil
        return temp
      end
      temp = min_value(node.right)
      node.data = temp.data
      node.right = delete(node.right, temp.data)
    end
    node
  end

  def find(value)
    node = preorder { |node| return node if node == value }
  end

  def find_parent(value)
    return nil if @root == value

    node = preorder { |node| return node if node.left == value || node.right == value }
  end

  def height(node = @root)
    return -1 if find(node).nil?

    node = find(node) unless node.instance_of?(Node)

    [height(node.left), height(node.right)].max + 1
  end

  def depth(node = @root)
    count = 0
    return 0 if node == @root

    node = find(node) unless node.instance_of?(Node)

    until find_parent(node.data).nil?
      count += 1
      node = find_parent(node.data)
    end
    count
  end

  def balanced?(node = @root)
    return true if node.nil?

    left = height(node.left)
    right = height(node.right)

    return true if (left - right).abs <= 1 && balanced?(node.left) && balanced?(node.right)

    false
  end

  def rebalance
    arr = inorder
    n = arr.length
    @root = build_tree(arr, 0, n - 1)
  end

  private

  def build_tree(array, start, fin)
    return nil if start > fin

    mid = (start.to_i + fin.to_i) / 2
    node = Node.new(array[mid])
    node.left = build_tree(array, start, mid - 1)
    node.right = build_tree(array, mid + 1, fin)
    node
  end

  def min_value(node)
    return node = node.left until node.left.nil?
  end
end
