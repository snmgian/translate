require 'lib/translator'

require 'minitest/autorun'
require 'rr'

class TestTranslator < MiniTest::Unit::TestCase
  include RR::Adapters::RRMethods

  def test_translate
    text = 'text'
    from = 'fr'
    to = 'it'

    mock(Translator).get(Translator::TRANSLATE_URI, :query => {:text => text, :sl => from, :tl => to }) { :translation }
    mock(Translator).parse_translation(:translation)

    r = Translator.translate(text, from, to)

    RR.verify
  end

  def test_parse_translation
    translation = [[["conjunto", "set", "", ""]],
     [["noun",
       ["conjunto",
        "grupo"]],
      ["verb",
       ["establecer",
        "fijar"]],
      ["adjective",
       ["establecido",
        "fijado"]]],
     "en",
     nil,
     [["conjunto", [5], 1, 0, 537, 0, 1, 0]],
     [["set", 4, nil, nil, ""],
      ["set",
       5,
       [["conjunto", 537, 1, 0],
        ["establecer", 259, 1, 0],
        ["establecido", 101, 1, 0],
        ["set", 60, 1, 0],
        ["serie", 42, 1, 0]],
       [[0, 3]],
       "set"]],
     nil,
     nil,
     [["en"]],
     5]

    main_translation, nouns, verbs, adjectives = Translator.parse_translation(translation)

    assert_equal 'conjunto', main_translation
    assert_equal ['conjunto', 'grupo'], nouns
    assert_equal ['establecer', 'fijar'], verbs
    assert_equal ['establecido', 'fijado'], adjectives
  end

  def test_parse_translation_with_no_verbs_and_adjectives
    translation = [[["gato", "cat", "", ""]],
     [["noun", ["gato", "gata", "felino"]],
      ["abbreviation", ["TAO", "traduccion asistida por ordenador"]]],
     "en",
     nil,
     [["gato", [5], 1, 0, 1000, 0, 1, 0]],
     [["cat", 4, nil, nil, ""],
      ["cat",
       5,
       [["gato", 1000, 1, 0],
        ["cat", 0, 1, 0],
        ["gatos", 0, 1, 0],
        ["del gato", 0, 1, 0],
        ["gata", 0, 1, 0]],
       [[0, 3]],
       "cat"]],
     nil,
     nil,
     [["en"]],
     4]

    main_translation, nouns, verbs, adjectives = Translator.parse_translation(translation)

    assert_equal 'gato', main_translation
    assert_equal ['gato', 'gata', 'felino'], nouns
    assert_equal [], verbs
    assert_equal [], adjectives
  end

  def test_parse_with_no_verbs_nouns_and_adjectives
    translation = [[["saltar", "saltar", "", ""]],
     nil,
     "en",
     nil,
     [["saltar", [5], 1, 0, 940, 0, 1, 0]],
     [["saltar",
       5,
       [["saltar", 940, 1, 0], ["de saltar", 0, 1, 0]],
       [[0, 6]],
       "saltar"]],
     nil,
     nil,
     [["es", "pt", "gl"]],
     10]

    main_translation, nouns, verbs, adjectives = Translator.parse_translation(translation)

    assert_equal 'saltar', main_translation
    assert_equal [], nouns
    assert_equal [], verbs
    assert_equal [], adjectives
  end

  def test_parse_with_no_nouns_and_adjectives
    translation = [[["jump", "saltar", "", ""]],
     [["verb",
       ["jump",
        "leap"]]],
     "es",
     nil,
     [["jump", [5], 1, 0, 995, 0, 1, 0]],
     [["saltar", 4, nil, nil, ""],
      ["saltar",
       5,
       [["jump", 995, 1, 0],
        ["hop", 2, 1, 0],
        ["leap", 1, 1, 0],
        ["Skip", 0, 1, 0],
        ["jumping", 0, 1, 0]],
       [[0, 6]],
       "saltar"]],
     nil,
     nil,
     [["es"]],
     5]

    main_translation, nouns, verbs, adjectives = Translator.parse_translation(translation)

    assert_equal 'jump', main_translation
    assert_equal [], nouns
    assert_equal ['jump', 'leap'], verbs
    assert_equal [], adjectives
  end
end
