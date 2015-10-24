# Description:
#   おみくじ
#
# Notes:
#   引くのだ！

module.exports = (robot) ->

  fortunes = ['大吉', '特吉', '凶[°-°]凶']
  robot.hear /^((おみくじ)|(omikuji))$/i, (res) ->
    res.reply res.random fortunes

