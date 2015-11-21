module.exports = (robot) ->
  traininfoEndpoint = process.env.HUBOT_TRAININFO_ENDPOINT
  traininfoKey = process.env.HUBOT_TRAININFO_KEY
  traininfoURL = "#{traininfoEndpoint}/information"
  traininfoListURL = "#{traininfoEndpoint}/list"

  robot.respond /traininfo list$/i, (msg) ->
    robot.http(traininfoListURL)
      .query(key: traininfoKey)
      .get() (err, res, body) ->
        json = JSON.parse body
        trainList = json.ResultSet.Line
        msg.send trainList[0].Name
