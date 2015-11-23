module.exports = (robot) ->
  traininfoEndpoint = process.env.HUBOT_TRAININFO_ENDPOINT
  traininfoKey = process.env.HUBOT_TRAININFO_KEY
  traininfoURL = "#{traininfoEndpoint}/information"
  traininfoListURL = "#{traininfoEndpoint}/list"

  robot.respond /traininfo list( (.*))?$/i, (msg) ->
    reqCorp = msg.match[1]
    unless reqCorp?
      robot.http(traininfoListURL)
        .query(key: traininfoKey)
        .get() (err, res, body) ->
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
          json = JSON.parse body
          trainList = json.ResultSet.Line
          train_str = "#{reqCorp} ===\n"
          for train in trainList
            train_str += "#{train.Name}  "
          msg.send train_str

  robot.respond /traininfo (.*)$/i, (msg) ->
    reqLine = msg.match[1].replace(" ", "")
    robot.http(traininfoURL)
      .query(key: traininfoKey, railName: reqLine)
      .get() (err, res, body) ->
        if err
          msg.send "何かおかしいよ\n#{err}"
          return
        if res.statusCode isnt 200
          msg.send "OKって言えないみたいね"
          return
        json = JSON.parse body
        info = json.ResultSet.Information
        unless info?
          msg.send "#{reqLine}の情報はないよ"
          return
        if Array.isArray(info)
          info_str = ""
          for i in info
            info_str += "#{i.Comment[0].text}\n"
          msg.send info_str
        else
          msg.send info.Comment[0].text
