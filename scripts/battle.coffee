# Description:
#   ┌--------┐
#   | > 戦う |
#   | 呪文   |
#   | 防御   |
#   | 道具   |
#   └--------┘
#
# Notes:
#   hueta attack @dareka
#   hueta hoimi  @dareka
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

DEFAULT_HP = 100
MAX_ATTACK_POINT = 100

module.exports = (robot) ->
  robot.hear /^attack (.*)$/i, (res) ->
    myName = res.message.user.name
    enemyName = res.match[1]
    attackPoint = Math.ceil(Math.random() * MAX_ATTACK_POINT)
    _beforeHP = robot.brain.get(enemyName)
    beforeHP = if toString.call(_beforeHP) == "[object Null]" then DEFAULT_HP else _beforeHP
    afterHP = beforeHP - attackPoint
    robot.brain.set enemyName, afterHP
    res.send "#{myName} attack #{attackPoint}"
    res.send "#{enemyName}'s HP is #{afterHP}"
