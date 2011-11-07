require 'multi_json'
require 'httparty'
require 'pp'

class Translator
  include HTTParty

  TRANSLATE_URI = '/translate_a/t'

  base_uri "translate.google.com.uy"

  headers 'User-Agent' => "Mozilla/5.0 (X11; Linux x86_64; rv:2.0) Gecko/20100101 Firefox/4.0"

  default_params :client     => 't',
                 :hl         => :en,
                 :multires   => '1',
                 :otf        => '1',
                 :pc         => '1',
                 :ssel       => '0',
                 :tsel       => '0',
                 :sc         => '1'

  parser(
    Proc.new do |body, format|
      body.gsub!(/,,/, ',null,')
      body.gsub!(/,,/, ',null,')
      MultiJson.decode(body)
    end
  )

  def self.translate(text, from, to)
    translation = self.get TRANSLATE_URI, :query => {:text => text, :sl => from, :tl => to}
    self.parse_translation(translation)
  end

  def self.parse_translation(translation)
    main_translation = translation[0][0][0]

    collections = translation[1] || []

    nouns = collections.find { |collection| collection[0] == 'noun'} || []
    verbs = collections.find { |collection| collection[0] == 'verb'} || []
    adjectives = collections.find { |collection| collection[0] == 'adjective'} || []

    nouns = nouns[1] || []
    verbs = verbs[1] || []
    adjectives = adjectives[1] || []

    return main_translation, nouns, verbs, adjectives
  end
end

#pp Translator.translate("cat")
