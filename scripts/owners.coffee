# Description:
#   @hueta: 新しいお(父|母)さんよ soeda
#
# Notes:
#   set hueta owner
#

module.exports = (robot) ->
  robot.respond /新しい(お父さん|お母さん)だ?よ (.*)$/i, (res) ->
    try
      requestUser = res.message.user.name
      unless isOwnerName(requestUser)
        res.reply "怪しい人だ"
        return

      parentNickname = res.match[1]
      newOwnerName = res.match[2].replace('@', '').replace(':', '')
      ownerIDs = robot.brain.get("ownerIDs") or []
      newOwnerID = getUserIDFromName(newOwnerName)

      unless newOwnerID?
        res.send "@#{newOwnerName}: だれやねん"
      else if ownerIDs.indexOf(newOwnerID) >= 0
        res.send "知ってるよ"
      else
        ownerIDs.push(newOwnerID)
        robot.brain.set "ownerIDs", ownerIDs
        res.send "@#{newOwnerName}: #{parentNickname}!"

    catch error
      res.send error.message

  getUserIDFromName = (userName) ->
    users = robot.brain.data.users
    throw "users: #{users}" unless users?

    for key, value of users
      if value.name == userName
        return key

  isOwnerName = (userName) ->
    userID = getUserIDFromName(userName)
    ownerIDs = robot.brain.get("ownerIDs")
    return ownerIDs.indexOf(userID) >= 0
