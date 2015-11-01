# Description:
#   @hueta おやすみ
#
# Notes:
#   reboot hubot server
#

module.exports = (robot) ->
  robot.respond /おやすみ$/i, (res) ->
    res.reply "おやすみ"

    AWS = require('aws-sdk')
    data = new AWS.MetadataService()
    data.request "/latest/meta-data/instance-id/", (error, data) ->
      if error
        res.send "エラーだね #{error}"
      else
        res.send "データだね #{data}"
