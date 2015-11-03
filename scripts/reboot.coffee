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
    metadata = new AWS.MetadataService()

    metadata.request "/latest/meta-data/placement/availability-zone", (azErr, az) ->
      if azErr
        res.send "あれ、ベッドが見つからない\n#{azErr}"
      else
        region = az.match(/^(.*)\w$/i)[1]
        ec2 = new AWS.EC2(region: region)

        metadata.request "/latest/meta-data/instance-id/", (instIdErr, instId) ->
          if instIdErr
            res.send "寝れない\n#{instIdErr.stack}"
          else
            ec2.rebootInstances InstanceIds: [instId], (rebootErr, rebootRes) ->
              if rebootErr
                res.send "...?!\n#{rebootErr.stack}"
              else
                res.send "...zzZ"