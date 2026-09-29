module ApplicationHelper
  # 金額を3桁区切り＋「円」表記にする（例: 1000 -> "1,000円"）
  def yen(amount)
    "#{number_with_delimiter(amount)}円"
  end
end
