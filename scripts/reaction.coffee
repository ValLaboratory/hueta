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

  loadReaction = () ->
    reactions = {}
    reactionsCount = robot.brain.get('reactions') * 1 or 0
    for i in [0..reactionsCount - 1]
      reactions["reactionPatterns#{i}"] = (robot.brain.get("reactionPatterns#{i}"))
      reactions["reactionMessages#{i}"] = (robot.brain.get("reactionMessages#{i}"))
    reactions

  loadedPatterns = {}
  reloadPattern = () ->
    reactions = robot.brain.get('reactions') * 1 or 0
    if reactions > 0
      for i in [0..reactions - 1]
        k = robot.brain.get("reactionPatterns#{i}")
        v = robot.brain.get("reactionMessages#{i}")
        if !loadedPatterns[k]
          loadedPatterns[k] = v
          register = () ->
            s = v
            k_ = k
            robot.hear ///#{k}///, (res) ->
              res.send s if loadedPatterns[k_] == s
          register()
  reloadPattern()

  robot.respond /react --list/i, (res) ->
    reactions = robot.brain.get('reactions') * 1 or 0
    if reactions > 0
      res.reply "=== begin of list ==="
      for i in [0..reactions - 1]
        k = robot.brain.get("reactionPatterns#{i}")
        v = robot.brain.get("reactionMessages#{i}")
        res.reply "#{k} -> #{v}"
      res.reply "=== end of list ==="
    else
      res.reply 'no entry'

  robot.respond /react --reload/i, (res) ->
    reloadPattern()

  robot.respond /react --reset/i, (res) ->
    reactions = robot.brain.get('reactions') * 1 or 0
    if reactions > 0
      for i in [0..reactions - 1]
        robot.brain.remove("reactionPatterns#{i}")
        robot.brain.remove("reactionMessages#{i}")
        robot.brain.set "reactions", 0
      res.reply "=== reset complete ==="
      robot.brain.save()
    loadedPatterns = {}

  robot.respond /react (.*) (.*)/i, (res) ->    
    pattern = res.match[1]
    response = res.match[2]
    reactions = robot.brain.get('reactions') * 1 or 0
    robot.brain.set "reactionPatterns#{reactions}", pattern
    robot.brain.set "reactionMessages#{reactions}", response
    robot.brain.set 'reactions', reactions + 1
    robot.brain.save()
    reloadPattern()
    res.reply 'pattern has been set.'


