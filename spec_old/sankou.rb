# class Zengin
#   class Bank
#     attr_accessor :bank_code, :name
#   end

#   class BankCollection
#     include Enumerable

#     def each
#       return self unless block_given?

#       # `@pager`はスクレイピングのクライアント
#       # `query_selector`とかは適当な名前のメソッド
#       @pager.query_selector(...).each do |pager| # 頭文字をクリックしたあとのページのイメージ
#         pager.query_selector(...).each do |tr| # 銀行のテーブルから1行ずつスクレイピングするイメージ
#           bank = Bank.new(
#             bank_code: tr.query_selector(...).inner_text,
#             name:      tr.query_selector(...).inner_text,
#           )
#           yield bank
#         end
#       end
#     end
#   end

#   def self.banks
#     BankCollection.new
#   end
end