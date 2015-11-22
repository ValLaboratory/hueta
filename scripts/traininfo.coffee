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
          robot.logger.info reqCorp
          robot.logger.info body
          json = JSON.parse body
          trainList = json.ResultSet.Line
          train_str = "#{reqCorp} ===\n"
          for train in trainList
            train_str += "#{train.Name}  "
          msg.send train_str
