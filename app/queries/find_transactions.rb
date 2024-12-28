class FindTransactions
  attr_reader :transactions

  def initialize(transactions = initial_scope)
    @transactions = transactions
  end

  def call(params = {})
    scoped = transactions
    scoped = filter_by_type(scoped, params[:transaction_type])
    scoped = filter_by_category(scoped, params[:category])
    scoped = filter_by_bank(scoped, params[:bank])
    scoped = search_by_query_text(scoped, params[:query_text])
    sort(scoped, "date DESC")
  end

  private

  def initial_scope
    Transaction.all
  end

  def filter_by_type(scoped, type)
    return scoped unless type.present?
    scoped.where(transaction_type: type)
  end

  def filter_by_category(scoped, category)
    return scoped unless category.present?
    scoped.where(category_id: category)
  end

  def filter_by_bank(scoped, bank)
    return scoped unless bank.present?
    scoped.where(bank_id: bank)
  end

  def search_by_query_text(scoped, query_text)
    return scoped unless query_text.present?
    scoped.search_full_text(query_text)
  end

  def sort(scoped, order_by)
    scoped.order(order_by).load_async
  end
end
