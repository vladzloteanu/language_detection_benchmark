#!/usr/bin/ruby

require 'pry'
require 'active_support'
require 'active_support/core_ext/string'

require 'language_detector'
require 'whatlanguage'
require 'easy_translate'

module LanguageDetectionBenchmark

  class TextsLoader

    def texts_corpus
      @texts_corpus ||= load_texts
    end

    private

    def load_texts
      {}.tap do |result|
        files.each do |file|
          content_origin = File.basename(file, ".*")
          result[content_origin] = YAML.load(File.open(file))
        end
      end
    end

    def files
      Dir["tests/*.yml"]
    end

  end

  class Bench

    CORRESPONDANCES = {
        'english' => 'en',
        'scots' => 'en',
        'dutch' => 'nl',
        'german' => 'de',
        'french' => 'fr',
        'romanian' => 'ro'
    }

    delegate :texts_corpus, :to => 'texts_loader'

    def detect_language(text)
      raise "Not implemented!"
    end

    def benchs
      #%w( google_translate_api language_detector language_detector_tc )
      %w( google_api language_detector language_detector_tc whatlanguage )
    end

    def detector_for(bench)
      "LanguageDetectionBenchmark::#{bench.camelize}Bench".constantize.new
    end

    def benchmark!
      reset_results!

      benchs.each do |bench|
        @detector = detector_for(bench)
        each_text do |text, language, origin|
          detected_language = @detector.detect_language text
          ack_result!(text, language, origin, detected_language.to_s, bench)
        end
      end

      puts @results.inspect
    end

    private
    def reset_results!
      @results = {}
    end

    def ack_result!(text, language, origin, detected_language, detector_name)
      puts "#{language}, #{detected_language}"
      @results["#{detector_name}-#{origin}"] ||= {}
      @results["#{detector_name}-#{origin}"][language] ||= {}
      @results["#{detector_name}-#{origin}"][language]['correct'] ||= 0
      @results["#{detector_name}-#{origin}"][language]['correct'] += 1 if(language == detected_language)
      @results["#{detector_name}-#{origin}"][language]['total'] ||= 0
      @results["#{detector_name}-#{origin}"][language]['total'] += 1
    end

    def texts_loader
      @texts_loader ||= TextsLoader.new
    end

    def each_text
      texts_corpus.each do |origin, texts_by_language|
        texts_by_language.each do |language, texts_array|
          texts_array.each do |text|
            yield text, language, origin
          end
        end
      end
    end

    def canonical_language(language)
      CORRESPONDANCES[language.to_s] || language
    end

  end

  class GoogleTranslateApiBench < Bench

    def detect_language(text)
      :en
    end

  end

  class LanguageDetectorBench < Bench

    def detect_language(text)
      language = detector.detect(text)
      canonical_language(language)
    end

    private
    def detector
      @detector ||= LanguageDetector.new
    end

  end

  class LanguageDetectorTcBench < LanguageDetectorBench

    def detector
      @detector ||= LanguageDetector.new('tc')
    end

  end

  class WhatlanguageBench < LanguageDetectorBench

    def detect_language(text)
      canonical_language text.language
    end

  end

  class GoogleApiBench < Bench

    def detect_language(text)
      canonical_language text.language

      #result = client.execute(
      #  :api_method => translate.detections.list,
      #  :parameters => {
      #    'key' => api_key,
      #    'q' => 'buna ziua!'
      #      }
      #)

      ::EasyTranslate.detect text, :key => api_key
    end

    private
    #def client
    #  @client ||= Google::APIClient.new(:key => api_key)
    #end
    #
    #def translate
    #  client.discovered_api('translate', 'v2')
    #end

    def api_key
      Config['google']['api_key']
    end

  end

  module Config

    class << self

      delegate :[], :to => 'config_hash'

      def config_hash
        @config_hash ||= YAML.load(File.open('config.yml')).freeze
      end

    end

  end

end

LanguageDetectionBenchmark::Bench.new.benchmark!