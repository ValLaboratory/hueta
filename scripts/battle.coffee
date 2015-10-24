# Description:
#   ┌--------┐
#   | > 戦う |
#   |   呪文 |
#   |   防御 |
#   |   道具 |
#   └--------┘
#
# Notes:
#   hueta attack @dareka
#   hueta hoimi  @dareka
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

DEFAULT_HP = 100
MAX_ATTACK_POINT = 100
MAX_RECOVERY_POINT = 100

module.exports = (robot) ->
  robot.hear /^members$/i, (res) ->
    res.send robot.brain.data.users

  robot.hear /^attack (.*)$/i, (res) ->
    myName = res.message.user.name
    enemyName = res.match[1]
    beforeHP = getHP(enemyName)
    attackPoint = randomPoint(MAX_ATTACK_POINT)
    afterHP = beforeHP - attackPoint
    afterHP = 0 if afterHP < 0

    robot.brain.set enemyName, afterHP
    robot.brain.save
    res.send "#{myName} attack #{attackPoint}"
    res.send "#{enemyName}'s HP is #{afterHP}"

  robot.hear /^hoimi (.*)$/i, (res) ->
    doctorName = res.message.user.name
    patientName = res.match[1]

    beforeHP = getHP(patientName)
    recoveryPoint = randomPoint(MAX_RECOVERY_POINT)
    afterHP = beforeHP + recoveryPoint
    afterHP = DEFAULT_HP if afterHP > DEFAULT_HP

    robot.brain.set patientName, afterHP
    robot.brain.save
    res.send "#{doctorName} hoimi #{recoveryPoint}"
    res.send "#{patientName}'s HP is #{afterHP}"

  getHP = (personName) ->
    _HP = robot.brain.get(personName)
    valueClassName = toString.call(_HP)
    if valueClassName == "[object Null]"
      DEFAULT_HP
    else
      _HP

randomPoint = (maxPoint) ->
  Math.ceil(Math.pow(Math.random(), 20) * maxPoint)
