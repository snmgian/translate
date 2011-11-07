require 'lib/args_parser'

require 'minitest/autorun'

class TestTranslator < MiniTest::Unit::TestCase

  def test_parse
    text, from, to = ArgsParser.parse([:text, :en, :es])

    assert_equal :text, text
    assert_equal :en, from
    assert_equal :es, to
  end

  def test_parse_no_langs
    text, from, to = ArgsParser.parse([:text], :fr, :it)

    assert_equal :text, text
    assert_equal :fr, from
    assert_equal :it, to
  end

  def test_parse_one_lang
    text, from, to = ArgsParser.parse([:text, :it], :en, :es)

    assert_equal :text, text
    assert_equal :es, from
    assert_equal :it, to
  end

end
