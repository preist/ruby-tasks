def format_duration(total)
  raise "Function only accepts a non-negative integer" if total < 0
  return "now" if total == 0

  years, rs   = total.divmod(60 * 60 * 24 * 365)
  days, rs    = rs.divmod(60 * 60 * 24)
  hours, rs   = rs.divmod(60 * 60)
  minutes, rs = rs.divmod(60)
  seconds     = rs

  wordify = ->(x, word) { x.zero? ? nil : "#{x} #{word}#{'s' unless x == 1}" }

  words = [
  	wordify.call(years, "year"),
  	wordify.call(days, "day"),
  	wordify.call(hours, "hour"),
  	wordify.call(minutes, "minute"),
  	wordify.call(seconds, "second")
  ].compact

  words.length == 1 ? words.last : words[0..-2].join(', ') + " and #{words.last}"
end