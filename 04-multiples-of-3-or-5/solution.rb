def solution(number)
  (2...number).select { |n| n.modulo(3).zero? || n.modulo(5).zero? }.inject(&:+)
end