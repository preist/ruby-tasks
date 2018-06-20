require "minitest/autorun"
require_relative "valid_ip"

class ValidIpTest < Minitest::Test
  def test_valid_ip_01
    ip = "127.0.0.1"
    assert(valid_ip?(ip), "#{ip} should be valid.")
  end

  def test_valid_ip_0
    ip = "255.255.255.255"
    assert(valid_ip?(ip), "#{ip} should be valid.")
  end

  def test_valid_ip_03
    ip = "0.0.0.0"
    assert(valid_ip?(ip), "#{ip} should be valid.")
  end

  def test_invalid_ip_01
    ip = "255.255.255."
    refute(valid_ip?(ip), "#{ip} should NOT be valid.")
  end

  def test_invalid_ip_02
    ip = "025.255.255.255"
    refute(valid_ip?(ip), "#{ip} should NOT be valid.")
  end

  def test_invalid_ip_03
    ip = ".255.255.255"
    refute(valid_ip?(ip), "#{ip} should NOT be valid.")
  end

  def test_invalid_ip_04
    ip = "255.255..255"
    refute(valid_ip?(ip), "#{ip} should NOT be valid.")
  end

  def test_invalid_ip_05
    ip = "255.255.255"
    refute(valid_ip?(ip), "#{ip} should NOT be valid.")
  end

  def test_invalid_ip_06
    ip = "256.255.255.255"
    refute(valid_ip?(ip), "#{ip} should NOT be valid.")
  end

  def test_invalid_ip_07
    ip = "some_random_string"
    refute(valid_ip?(ip), "#{ip} should NOT be valid.")
  end
end
