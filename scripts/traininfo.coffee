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
        corpList = json.ResultSet.Corporation
        trainList = json.ResultSet.Line
        corps_str = "corps ==="
        for corp in corpList
          corps_str += "  #{corp.Name}"
        msg.send "#{corps_str}"
