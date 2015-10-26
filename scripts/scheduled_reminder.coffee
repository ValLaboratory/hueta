# Description:
#   簡易リマインダ
#
# Notes:
#   hueta remind on 15:00

module.exports = (robot) ->

  robot.respond /remind on (\d{1,2}):(\d{1,2}) *(.*)/i, (res) ->
    now = new Date();
    target = new Date(now.getFullYear(), now.getMonth(), now.getDate(), res.match[1], res.match[2], 0, 0)
    res.reply "#{res.match[1]}:#{res.match[2]} （#{Math.ceil((target.getTime() - now.getTime()) / 1000 / 60)}分後）にリマインダを設定しました。"
    do ->
      message = if !(res.match[3] && res.match[3].trim()) then 'リマインダが設定された時刻です！' else res.match[3]
      setTimeout () ->
       res.reply "<!channel> #{message}"
      , target.getTime() - now.getTime()
