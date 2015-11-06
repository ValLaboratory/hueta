# Description:
#   @hueta: 新しいお(父|母)さんよ soeda
#
# Notes:
#   set hueta owner
#

module.exports = (robot) ->
  robot.respond /新しい(お父さん|お母さん)だ?よ (.*)$/i, (res) ->
    parentNickname = res.match[1]
    newOwnerName = res.match[2].replace('@', '').replace(':', '')
    ownerIDs = robot.brain.get("ownerIDs") or []
    newOwnerID = getUserIDFromName(newOwnerName)
    if ownerIDs.indexOf(newOwnerID) >= 0
      res.send "知ってるよ"
    else
      ownerIDs.push(newOwnerID)
      robot.brain.set "ownerIDs", ownerIDs
      res.send "@#{newOwnerName}: #{parentNickname}!"

  getUserIDFromName = (userName) ->
    userName