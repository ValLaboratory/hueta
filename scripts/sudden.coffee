# Description:
# ＿人人人人人人人人＿
# ＞　突然の文字列　＜
# ￣Y^Y^Y^Y^Y^Y^Y ￣
#
# Notes:
#   突然の文字列
#

module.exports = (robot) ->
  robot.hear /^突然の(.*)$/i, (res) ->
    res.send suddenString(res.match[0])

suddenString = (str) ->
  strLength = str.enLength()
  """
  ＿人#{'人'.repeat(strLength / 2)}人＿
  ＞　#{str}　＜
  ￣Y^#{'Y^'.repeat(strLength / 2)}Y￣
  """

String.prototype.enLength = () ->
  len = 0
  for i in [0...(this.length)]
    charCode = this.charCodeAt(i)
    if charCode <= 0xff || 0xff61 <= charCode <= 0xff9f
      len += 1
    else
      len += 2
  return len

String.prototype.repeat = (num) ->
  str = ""
  str += this while str.length <= this.length * (num - 1)
  return str
