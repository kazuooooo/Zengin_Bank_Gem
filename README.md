# Zengin_Bank_Gem
###口座情報をスクレイピングするgemの作成

ActiveSupportっぽく使えるものにする(BankとかBranchとか)

ポイント
1 誰のために作るのか (gemを使う人が使いやすいインターフェースを目指す)
2 documentationが必要
3 test (rspec)

銀行コードのデータが多すぎるので全部メモリーに入れない
リクエストの数はなるべく少なく

スクレイピングに依存しているgemは使わない

ActiveSupportは使わない (大きすぎるので)

まず遊んでみる
↓
仕様を決める（csvに落とせるようにするのか、コマンドラインツールを作るのか)
↓
作る
