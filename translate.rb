require 'lib/args_parser'
require 'lib/translator'

require 'pp'

DEFAULT_FROM_LANG = :en
DEFAULT_TO_LANG = :es

text, from, to = ArgsParser.parse(ARGV, DEFAULT_FROM_LANG, DEFAULT_TO_LANG)

main_translation, nouns, verbs, adjectives = Translator.translate(text, from, to)

puts main_translation, ''

print 'nouns: ', nouns.join(', '), $/, $/

print 'verbs: ', verbs.join(', '), $/, $/

print 'adjectives: ', adjectives.join(', '), $/, $/
