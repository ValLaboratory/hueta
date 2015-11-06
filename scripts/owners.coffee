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
    owners = robot.brain.get("owners") or []
    if owners.indexOf(newOwnerName) >= 0
      res.send "知ってるよ"
    else
      owners.push(newOwnerName)
      robot.brain.set "owners", owners
      res.send "@#{newOwnerName}: #{parentNickname}!"
