# Description:
#   文字入れ替えネタ生成
#
# Notes:
#   あとでかくかも

module.exports = function (robot) {
  robot.hear(/^(.*)  neta$/i, function (res) {
    res.reply(switchSentence(RegExp.$1));
  })
}

function event::onChannelText(prefix, channel, text) {
  if (text.match(/^(.*)  neta$/)) {
    send(channel, switchSentence(RegExp.$1));
  };
}
 
function switchSentence (text) {
  var splitted_text = text.split("  ");
  var params = splitted_text[1].split(",");
  var text = splitted_text[0];
  var length_list = parseLengthList(params);
  var text_list = splitTextByLengthList(text, length_list);
  var mode_list = parseModeList(params);
  var repeat_list = parseRepeatList(params);
  return rejoinTextsWithModes(text_list, mode_list, repeat_list);
}
 
function parseModeList (params) {
  var result = [];
  for (var i = 0; i < params.length; i++) {
    params[i].match(/^([+-])/);
    result.push(RegExp.$1);
  };
  return result;
}
 
function parseRepeatList (params) {
  var result = [];
  for (var i = 0; i < params.length; i++) {
    result.push(params[i].match(/\*/) != null);
  };
  return result;
}
 
function parseLengthList (params) {
  var result = [];
  for (var i = 0; i < params.length; i++) {
    params[i].match(/^[+-](\d*)/);
    var length_str = RegExp.$1;
    result.push(parseInt(length_str));
  };
  return result;
}
 
function splitTextByLengthList (text, length_list) {
  var result = [];
  for (var i = 0; i < length_list.length; i++) {
    result.push(text.slice(0, length_list[i]));
    text = text.slice(length_list[i]);
  };
  return result;
}
 
function rejoinTextsWithModes(text_list, mode_list, repeat_list) {
  var result = "";
  var randomized_list = randomizedTexts(text_list, mode_list, repeat_list);
  for (var i = 0; i < mode_list.length; i++) {
    if (mode_list[i] === "-") {
      result += text_list[i];
    } else {
      result += randomized_list.shift();
    }
  };
  return result;
}
 
function randomizedTexts(text_list, mode_list, repeat_list) {
  var result = [];
  var random_count = 0;
  for (var i = 0; i < mode_list.length; i++) {
    if (mode_list[i] === "+") {
      random_count++;
    }
  }
  for (var i = 0; i < mode_list.length; i++) {
    if (mode_list[i] === "+") {
      if (repeat_list[i]) {
        for (var j = random_count - 1; j >= 0; j--) {
          result.push(text_list[i]);
        };
      } else {
        result.push(text_list[i]);
      }
    };
  };
  return shuffle(result);
}
 
function shuffle(a) {
  for (var i = a.length-1; i >= 0; i--) {
    var r = Math.round(i * Math.random());
    var tmp = a[i];
    a[i] = a[r];
    a[r] = tmp;
  }
  return a;
}
