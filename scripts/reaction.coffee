# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->

  clone = (obj) ->
    return obj  if obj is null or typeof (obj) isnt "object"
    temp = new obj.constructor()
    for key of obj
      temp[key] = clone(obj[key])
    temp

  loadedPatterns = []
  reloadPattern = () ->
    reactions = robot.brain.get('reactions') or []
    for key, value of reactions
      if !loadedPatterns[key]
        loadedPatterns[key] = value
        robot.hear ///#{key}///, (res) ->
          res.send clone(value)

  robot.respond /react --list/i, (res) ->
    reactions = robot.brain.get('reactions') or []
    if Object.keys(reactions).length > 0
      res.reply "=== begin of list ==="
      for key, value of reactions
        res.reply "#{key} -> #{value}"
      res.reply "=== end of list ==="
    else
      res.reply 'no entry'

  robot.respond /react --reload/i, (res) ->
    reloadPattern()

  robot.respond /react --reset/i, (res) ->
    robot.brain.set('reactions', [])

  robot.respond /react (.*) (.*)/i, (res) ->    
    pattern = res.match[1]
    response = res.match[2]
    reactions = robot.brain.get('reactions') or []
    reactions[pattern] = response
    robot.brain.set 'reactions', reactions
    robot.brain.save
    reloadPattern()
    res.reply 'pettern has been set.'


