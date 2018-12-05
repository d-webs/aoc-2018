class LLNode
  attr_accessor :next, :prev
  attr_reader :val

  def initialize(val, nxt = nil, prev = nil)
    @val = val
    @next = nxt
    @prev = prev
  end

  def remove
    @prev.next = @next
    @next.prev = @prev
    @next, @prev = nil, nil
    self
  end

  def inspect
    "#<LLNode: val: #{val}, next: #{self.next.val}, prev: #{prev.val}>"
  end
end

## Doubly Linked List
class LinkedList
  attr_reader :head, :tail
  def initialize
    @head = LLNode.new(:HEAD)
    @tail = LLNode.new(:TAIL)
    @head.next = @tail
    @tail.prev = @head
  end

  def insert(val)
    if empty?
      new_node = LLNode.new(val, tail, head)
      head.next = new_node
      tail.prev = new_node

      new_node.prev, new_node.next = head, tail
    else
      prev_node = tail.prev
      new_node = LLNode.new(val, tail, prev_node)
      prev_node.next = new_node
      tail.prev = new_node
    end

    new_node
  end

  def empty?
    head.next.val == :TAIL
  end

  def first
    empty? ? nil : head.next
  end

  def last
    empty? ? nil : tail.prev
  end
end