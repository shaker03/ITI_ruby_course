class Bank
  def process_transactions(transactions, &block)
    raise "Method #{__method__} is abstract and should be implemented in the child class"
  end
end
