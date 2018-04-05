# Description:
#  @hueta traininfo list
#  @hueta traininfo list ＪＲ
#  @hueta traininfo ＪＲ東海道本線(東京－熱海)
#
# Notes:
#   突然の文字列
#

module.exports = (robot) ->
  traininfoEndpoint = process.env.HUBOT_TRAININFO_ENDPOINT
  traininfoKey = process.env.HUBOT_TRAININFO_KEY
  traininfoURL = "#{traininfoEndpoint}/information"
  traininfoListURL = "#{traininfoEndpoint}/list"

  robot.respond /trainlist( (.*))?$/i, (msg) ->
    reqCorp = msg.match[1]
    unless reqCorp?
      robot.http(traininfoListURL)
        .query(key: traininfoKey)
        .get() (err, res, body) ->
          if err
            msg.send "何かおかしいよ\n#{err}"
            return
          if res.statusCode isnt 200
            msg.send "OKって言えないみたいね"
            return
          json = JSON.parse body
          corpList = json.ResultSet.Corporation
          corps_str = "corps ===\n"
          for corp in corpList
            corps_str += "#{corp.Name}  "
          msg.send "#{corps_str}"
    else
      reqCorp = reqCorp.replace(" ", "")
      robot.http(traininfoListURL)
        .query(key: traininfoKey, corporationName: reqCorp)
        .get() (err, res, body) ->
          if err
            msg.send "何かおかしいよ\n#{err}"
            return
          if res.statusCode isnt 200
            msg.send "OKって言えないみたいね"
            return
          json = JSON.parse body
          trainList = json.ResultSet.Line
          train_str = "#{reqCorp} ===\n"
          if Array.isArray(trainList)
            for train in trainList
              train_str += "#{train.Name}  "
          else
            train_str += trainList.Name
          msg.send train_str

  robot.respond /traininfo (.*)$/i, (res) ->
    reqLine = res.match[1].replace(" ", "")
    result = getTraininfo(reqLine, sendResult)
    sendResult = () ->
      robot.logger.info result
      res.send result

  getTraininfo = (lineName, callback) ->
    robot.http(traininfoURL)
      .query(key: traininfoKey, railName: lineName)
      .get() (err, res, body) ->
        return "何かおかしいよ\n#{err}" if err
        return "OKって言えないみたいね" if res.statusCode isnt 200

        json = JSON.parse body
        info = json.ResultSet.Information
        return "#{lineName}の情報はないよ" unless info?

        if Array.isArray(info)
          infoStr = ""
          for i in info
            infoStr += "#{i.Comment[0].text}\n"
          return infoStr
        else
          return info.Comment[0].text

        callback
