require 'pry'
require 'active_support'
require 'active_support/core_ext/string'

require 'language_detector'

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

    delegate :texts_corpus, :to => 'texts_loader'

    def detect_language(text)
      raise "Not implemented!"
    end

    def benchs
      #%w( google_translate_api language_detector language_detector_tc )
      %w( language_detector language_detector_tc )
    end

    def bench_classes
      benchs.map{|bench| "LanguageDetectionBenchmark::#{bench.camelize}Bench".constantize }
    end

    def benchmark!
      bench_classes.each do |klass|
        @detector = klass.new
        each_text do |text, language, origin|
          detected_language = @detector.detect_language text
          puts "#{language}, #{detected_language}"
        end
      end
    end

    private
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

  end

  class GoogleTranslateApiBench < Bench

    def detect_language(text)
      :en
    end

  end

  class LanguageDetectorBench < Bench

    CORRESPONDANCES = {
        'english' => 'en',
        'dutch' => 'du',
        'german' => 'de',
        'french' => 'fr',
        'romanian' => 'ro'
    }

    def detect_language(text)
      language = detector.detect(text)
      canonical_language(language)
    end

    private
    def detector
      @detector ||= LanguageDetector.new
    end

    def canonical_language(language)
      CORRESPONDANCES[language.to_s] || language
    end

  end

  class LanguageDetectorTcBench < LanguageDetectorBench

    def detector
      @detector ||= LanguageDetector.new('tc')
    end

  end

end

LanguageDetectionBenchmark::Bench.new.benchmark!