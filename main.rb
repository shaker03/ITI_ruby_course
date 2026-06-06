require "./user.rb"
require "./transaction.rb"
require "./cba_bank.rb"

users = [
  User.new("Ali", 200),
  User.new("Peter", 500),
  User.new("Manda", 100),
]

out_side_bank_users = [
  User.new("Menna", 400),
]

transactions = [
  Transaction.new(users[0], -20),
  Transaction.new(users[0], -30),
  Transaction.new(users[0], -50),
  Transaction.new(users[0], -100),
  Transaction.new(users[0], -100),
  Transaction.new(out_side_bank_users[0], -100),
]

my_bank = CBABank.new(users)

# Process the transactions and print the result of each transaction in the block
my_bank.process_transactions(transactions) do |is_success, transaction, error_msg|
  if is_success
    puts "Call endpoint for success of #{transaction.to_s}"
  else
    puts "Call endpoint for failure of #{transaction.to_s} with reason #{error_msg}"
  end
end
