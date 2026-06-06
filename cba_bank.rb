require "./bank.rb"
require "./logger.rb"

class CBABank < Bank
  include Logger

  def initialize(bank_users)
    @bank_users = bank_users
  end

  def process_transactions(transactions, &block)
    transaction_names = transactions.map { |t| t.to_s }.join(", ")
    log_info("Processing Transactions #{transaction_names}...")

    transactions.each do |transaction|
      begin
        #Process each transaction one by one
        if !@bank_users.include?(transaction.user)
          raise "Warning: #{transaction.user.name} not exist in the bank"
        end

        new_balance = transaction.user.balance + transaction.value
        #check if the new balance is negative
        if new_balance < 0
          raise "Warning: Not enough balance"
        end

        #update the balance of the user after the transaction
        transaction.user.balance = new_balance
        log_info("#{transaction.to_s} succeeded")

        #check if the balance is 0 after the transaction
        if transaction.user.balance == 0
          log_warning("#{transaction.user.name} has 0 balance")
        end

        block.call(true, transaction, nil)
      rescue => e
        log_error("#{transaction.to_s} failed with message #{e.message}")
        block.call(false, transaction, e.message)
      end
    end
  end
end
